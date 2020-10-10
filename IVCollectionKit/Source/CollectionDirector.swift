//
//  CollectionDirector.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.08.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

open class CollectionDirector: NSObject {
    /// Array of sections models
    public var sections = [AbstractCollectionSection]()
    ///Register cell classes & xibs automatically
    open var shouldUseAutomaticViewRegistration: Bool = false
    ///Adjust z position for headers/footers to prevent scroll indicator hiding at iOS11
    open var shouldAdjustSupplementaryViewLayerZPosition: Bool = true
    ///Forward scrollView delegate messages to specific object
    open weak var scrollDelegate: UIScrollViewDelegate?
    
    public weak var collectionView: UICollectionView!
    internal lazy var updater = CollectionUpdater(collectionView)
    internal lazy var viewsRegisterer = CollectionReusableViewsRegisterer(collectionView: collectionView)
    
    internal var sectionIds: [String] = []
    internal var lastCommitedSectionAndItemsIdentifiers: [String: [String]] = [:]
    
    var isEmpty: Bool {
        if sections.isEmpty {
            return true
        }
        
        return sections.reduce(true, { $0 && $1.numberOfItems() == 0 })
    }
    
    public init(collectionView: UICollectionView,
                sections: [AbstractCollectionSection] = [],
                shouldUseAutomaticViewRegistration: Bool = true,
                shouldAdjustSupplementaryViewLayerZPosition: Bool = true)
    {
        
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.shouldUseAutomaticViewRegistration = shouldUseAutomaticViewRegistration
        self.shouldAdjustSupplementaryViewLayerZPosition = shouldAdjustSupplementaryViewLayerZPosition
    }
    
    open func section(for index: Int) -> AbstractCollectionSection {
        return sections[index]
    }
    
    /// Save all section and items and sections identifiers "snapshot". It will be used to compare current state during next update
    private func createSnapshot() {
        sectionIds.removeAll()
        lastCommitedSectionAndItemsIdentifiers.removeAll()

        for s in sections {
            sectionIds.append(s.identifier)
            lastCommitedSectionAndItemsIdentifiers[s.identifier] = s.currentItemIds()
        }
    }
    
    /// dequeue cell for `CollectionSection` implementation & support automatic cell registration
    internal func private_dequeueReusableCell(of type: AnyClass, reuseIdentifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        if shouldUseAutomaticViewRegistration {
            viewsRegisterer.registerCellIfNeeded(reuseIdentifier: reuseIdentifier, cellClass: type)
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
}

//MARK:- Public
extension CollectionDirector {
    
    /// Dequeue cell and register cell identidifer
    public func dequeueReusableCell<T: UICollectionViewCell & Reusable>(indexPath: IndexPath) -> T {
        
        if shouldUseAutomaticViewRegistration {
            viewsRegisterer.registerCellIfNeeded(reuseIdentifier: T.reuseIdentifier, cellClass: T.self)
        }
        
        return collectionView.dequeue(indexPath: indexPath)
    }
    
    /// Invokes empty batch update block. Typical use case: re-calculate cell size or toggle state of expandable section
    public func setNeedsUpdate() {
        collectionView.performBatchUpdates({}, completion: nil)
    }
    
    public func remove(section: AbstractCollectionSection) {
        guard let index = sections.firstIndex(where: { $0.identifier == section.identifier }) else { return }
        
        sections.remove(at: index)
    }
    
    public func removeSection(at index: Int) {
        sections.remove(at: index)
    }
    
    /// Reloads collectionview and saves director state
    public func reload() {
        collectionView.reloadData()
        createSnapshot()
    }
    
    public func contains(section: AbstractCollectionSection) -> Bool {
        return sections.contains(where: { $0.identifier == section.identifier })
    }
    
    public func append(sectionsToAppend: [AbstractCollectionSection]) {
        sections.append(contentsOf: sectionsToAppend)
    }

    public func remove(sectionsToRemove: [AbstractCollectionSection]) {
        let indicies = sectionsToRemove.compactMap { [unowned self] sec in
            return self.sections.firstIndex(where: { $0 == sec })
        }
        
        sections.remove(at: indicies.sorted().reversed())
    }
    
    /// Calculates and performs managed UICollectionView updates based on diff between sections array state
    /// afert last update or reload and current state
    /// if `UICollectionView` is empty performs `reloadData` instead of batch updates to prevent crash
    /// - parameter forceReloadDataForLargeAmountOfChanges: if there is > 50 section changes perform reload data instead of animated updates. `false` by default
    /// - parameter completion: closure, which will be called after all updates has been performed. Nullable
    ///
    public func performUpdates(forceReloadDataForLargeAmountOfChanges: Bool = false,
                               completion: (() -> Void)? = nil) {
        
        let updates = updater.calculateUpdates(
            oldSectionIds: sectionIds,
            currentSections: sections,
            itemMap: lastCommitedSectionAndItemsIdentifiers,
            forceReloadDataForLargeAmountOfChanges: forceReloadDataForLargeAmountOfChanges)
        
        switch updates {
        case .reload:
            self.reload()
            completion?()
            return
        case .update(let sections, let items):
            createSnapshot()
            _performUpdates(sectionChanges: sections, itemChanges: items, completion: completion)
        }
    }
    
//    public func performUpdates(in section: AbstractCollectionSection, completion: (() -> Void)? = nil) {
//        guard let s = sections.first(where: { $0.identifier == section.identifier }) else { fatalError("Attempt to update") }
//
//        let updates = updater.calculateUpdates(
//            oldSectionIds: [s.identifier],
//            currentSections: [s],
//            itemMap: lastCommitedSectionAndItemsIdentifiers.filter { $0.key == section.identifier },
//            forceReloadDataForLargeAmountOfChanges: false)
//
//        switch updates {
//        case .reload:
//            reload()
//            return
//        case .update(let sections, let items):
//            createSnapshot()
//            _performUpdates(sectionChanges: sections, itemChanges: items, completion: completion)
//        }
//    }
    
    private func _performUpdates(sectionChanges: [Change<String>],
                                 itemChanges: ChangeWithIndexPath,
                                 completion: (() -> Void)?)
    {
        collectionView.performBatchUpdates({ [weak self] in
            guard let collectionView = self?.collectionView else { return }
            
            itemChanges.deletes.executeIfPresent { (deletes) in
                collectionView.deleteItems(at: deletes)
            }
            
            itemChanges.inserts.executeIfPresent { (inserts) in
                collectionView.insertItems(at: inserts)
            }
            
            itemChanges.moves.executeIfPresent { (moves) in
                moves.forEach { move in
                    collectionView.moveItem(at: move.from, to: move.to)
                }
            }
            
            let sectionDeletes = sectionChanges.compactMap { $0.delete?.index }
            sectionDeletes.executeIfPresent { deletes in
                self?.collectionView.deleteSections(IndexSet(deletes))
            }

            let sectionInserts = sectionChanges.compactMap { $0.insert?.index }
            sectionInserts.executeIfPresent { inserts in
                self?.collectionView.insertSections(IndexSet(inserts))
            }

            sectionChanges.compactMap { $0.move }.executeIfPresent { moves in
                moves.forEach { self?.collectionView.moveSection($0.fromIndex, toSection: $0.toIndex) }
            }
        }) { (_) in
            completion?()
        }
        
        itemChanges.replaces.executeIfPresent { [weak self] in
            self?.collectionView.reloadItems(at: $0)
        }

        sectionChanges.compactMap { $0.replace?.index }.executeIfPresent { [weak self] in
            self?.collectionView.reloadSections(IndexSet($0))
        }
    }
    
    /// Removes all sections from director
    /// - parameter clearSections: if `true` removes all items from sections. Remember, that you should override `removeAll()` method in your custom section. This method removes all items from array in `CollectionSection` implementation and does nothing by default
    public func removeAll(clearSections: Bool = false) {
        if clearSections {
            sections.forEach { $0.removeAll() }
        }
        
        sections.removeAll()
    }
    
    public func clearSections() {
        sections.forEach { $0.removeAll() }
    }
    
    public func append(section: AbstractCollectionSection) {
        sections.append(section)
    }
    
    public func insert(section: AbstractCollectionSection,
                       after afterSection: AbstractCollectionSection)
    {
        guard let afterIndex = sections.firstIndex(where: { afterSection == $0 }) else { return }
        sections.insert(section, at: afterIndex + 1)
    }
    
    public func insert(section: AbstractCollectionSection, at index: Int) {
        sections.insert(section, at: index)
    }
    
    public func append(sections: [AbstractCollectionSection]) {
        self.sections.append(contentsOf: sections)
    }
}

//MARK:- UICollectionViewDataSource
extension CollectionDirector: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section(for: section).numberOfItems()
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return section(for: indexPath.section).cell(for: self, indexPath: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.section(for: indexPath.section)

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = section.headerItem else { return UICollectionReusableView() }
            if shouldUseAutomaticViewRegistration {
                viewsRegisterer.registerHeaderFooterViewIfNeeded(reuseIdentifier: header.reuseIdentifier, viewClass: header.viewType, kind: kind)
            }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.reuseIdentifier, for: indexPath)
            header.configure(headerView)
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footer = section.footerItem else { return UICollectionReusableView() }
            if shouldUseAutomaticViewRegistration {
                viewsRegisterer.registerHeaderFooterViewIfNeeded(reuseIdentifier: footer.reuseIdentifier, viewClass: footer.viewType, kind: kind)
            }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footer.reuseIdentifier, for: indexPath)
            footer.configure(footerView)
            return footerView
            
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension CollectionDirector : UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        section(for: indexPath.section).didSelectItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        section(for: indexPath.section).didDeselectItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        section(for: indexPath.section).willDisplayItem(at: indexPath, cell: cell)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard sections.count > indexPath.section,
            section(for: indexPath.section).numberOfItems() > indexPath.row else { return }
        
        section(for: indexPath.section).didEndDisplayingItem(at: indexPath, cell: cell)
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        section(for: indexPath.section).shouldHighlightItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        section(for: indexPath.section).didHighlightItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        section(for: indexPath.section).didUnhighlightItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return section(for: indexPath.section).shouldSelect(at: indexPath)
    }

    // called when the user taps on an already-selected item in multi-select mode
    open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return section(for: indexPath.section).shouldDeselect(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.section(for: indexPath.section)
        
        let adjustsWidth = section.itemAdjustsWidth(at: indexPath.item)
        let adjustsHeight = section.itemAdjustsHeight(at: indexPath.item)
        
        let insets = collectionView.contentInset
        let boundingWidth = collectionView.bounds.width - insets.left - insets.right
        let boundingHeight = collectionView.bounds.height - insets.top - insets.bottom
        let boundingSize = CGSize(width: boundingWidth, height: boundingHeight)
        
        var size = section.sizeForItem(at: indexPath, boundingSize: boundingSize)
        
        let sectionInsets = section.insetForSection
        if adjustsWidth {
            let horizontalSectionInsets = sectionInsets.right + sectionInsets.left
            size.width = boundingWidth - horizontalSectionInsets
        }
        
        if adjustsHeight {
            let verticalSectionInsets = sectionInsets.top + sectionInsets.bottom
            size.height = boundingHeight - verticalSectionInsets
        }
        
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.section(for: section).insetForSection
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section_ = self.section(for: section)
        
        let value = section_.headerItem?.estimatedSize(boundingSize: collectionView.bounds.size, in: section_) ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section_ = self.section(for: section)
        let value = section_.footerItem?.estimatedSize(boundingSize: collectionView.bounds.size, in: section_) ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.section(for: section).minimumInterItemSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return self.section(for: section).lineSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             willDisplaySupplementaryView view: UICollectionReusableView,
                             forElementKind elementKind: String,
                             at indexPath: IndexPath)
    {
        guard sections.count > indexPath.section else { return }
        
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            section(for: indexPath.section).headerItem?.onDisplay?()
            break
        case UICollectionView.elementKindSectionFooter:
            section(for: indexPath.section).footerItem?.onDisplay?()
            break
        default:
            break
        }
        
        guard shouldAdjustSupplementaryViewLayerZPosition, #available(iOS 11.0, *) else { return }
        view.layer.zPosition = 0
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             didEndDisplayingSupplementaryView view: UICollectionReusableView,
                             forElementOfKind elementKind: String,
                             at indexPath: IndexPath)
    {
        guard sections.count > indexPath.section else { return }
        
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            section(for: indexPath.section).headerItem?.onEndDisplay?()
            break
        case UICollectionView.elementKindSectionFooter:
            section(for: indexPath.section).footerItem?.onEndDisplay?()
            break
        default:
            break
        }
    }
}

//MARK:- UIScrollViewDelegate
extension CollectionDirector : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
}

//MARK:- Responder chain
extension CollectionDirector {
    open override func responds(to selector: Selector) -> Bool {
        return super.responds(to: selector) || scrollDelegate?.responds(to: selector) == true
    }
    
    open override func forwardingTarget(for selector: Selector) -> Any? {
        return scrollDelegate?.responds(to: selector) == true ? scrollDelegate : super.forwardingTarget(for: selector)
    }
}
