//
//  ProductDetailDirector.swift
//  Marketplace
//
//  Created by Igor Vedeneev on 13.08.17.
//  Copyright © 2017 WeAreLT. All rights reserved.
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
    
    private weak var collectionView: UICollectionView!
    private lazy var updater = CollectionUpdater(collectionView: collectionView)
    private lazy var viewsRegisterer = CollectionReusableViewsRegisterer(collectionView: collectionView)
    
    private var sectionIds: [String] = []
    private var lastCommitedSectionAndItemsIdentifiers: [String: [String]] = [:]
    
    var isEmpty: Bool {
        if sections.isEmpty {
            return true
        }
        
        return sections.reduce(true, { $0 && $1.numberOfItems() == 0 })
    }
    
    public init(colletionView: UICollectionView,
                sections: [AbstractCollectionSection] = [],
                shouldUseAutomaticViewRegistration: Bool = true,
                shouldAdjustSupplementaryViewLayerZPosition: Bool = true)
    {
        
        self.collectionView = colletionView
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.shouldUseAutomaticViewRegistration = shouldUseAutomaticViewRegistration
        self.shouldAdjustSupplementaryViewLayerZPosition = shouldAdjustSupplementaryViewLayerZPosition
    }
    
    private func section(for index: Int) -> AbstractCollectionSection {
        return sections[index]
    }
    
    /// Save all section and items and sections identifiers "snapshot". It will be used to compare current state during next update
    private func createSnapshot() {
        sectionIds = sections.map { $0.identifier }
        
        lastCommitedSectionAndItemsIdentifiers = [:]

        for s in sections {
            lastCommitedSectionAndItemsIdentifiers[s.identifier] = s.currentItemIds()
        }
    }
}

//MARK:- Public
extension CollectionDirector {
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
                               completion: (() -> Void)? = nil)
    {
        let newSectionIds = self.sections.map { $0.identifier }
        let oldSectionIds = sectionIds
        let sectionChanges = diff(old: oldSectionIds, new: newSectionIds)

        // if there is no sections in cv, it crashes :(
        if oldSectionIds.isEmpty {
            reload()
            return
        }

        let converter = IndexPathConverter()
        var itemChanges = Array<ChangeWithIndexPath>()
        
        if sectionChanges.count > 50 && forceReloadDataForLargeAmountOfChanges {
            reload()
            completion?()
            return
        }
        
        self.sections.enumerated().forEach { [unowned self] (idx, section) in
            let oldItemIds = self.lastCommitedSectionAndItemsIdentifiers[section.identifier] ?? section.currentItemIds()
            let diff_ = diff(old: oldItemIds, new: section.currentItemIds())
            guard !diff_.isEmpty else { return }
            itemChanges.append(converter.convert(changes: diff_, section: idx))
        }
        
        createSnapshot()
        
        collectionView.performBatchUpdates({ [weak self] in
            guard let `self` = self else { return }

            itemChanges.forEach { (changesWithIndexPath) in
                
                changesWithIndexPath.deletes.executeIfPresent { deletes in
                    let indexPaths: [IndexPath]
                    
                    if !sectionChanges.isEmpty {
                        let oldSections = deletes
                            .map { newSectionIds[$0.section] }
                            .compactMap { oldSectionIds.firstIndex(of: $0) }
                        
                        indexPaths = zip(deletes, oldSections).map { IndexPath(item: $0.item, section: $1) }
                    } else {
                        indexPaths = deletes
                    }
                    
                    self.collectionView.deleteItems(at: indexPaths)
                }

                changesWithIndexPath.inserts.executeIfPresent {
                  self.collectionView.insertItems(at: $0)
                }

                changesWithIndexPath.moves.executeIfPresent {
                  $0.forEach { move in
                    let from: IndexPath
                    let to: IndexPath = move.to
                    if !sectionChanges.isEmpty {
                        let sectionId = newSectionIds[move.to.section]
                        guard let oldSectionIdx = oldSectionIds.firstIndex(of: sectionId) else {
                            fatalError("Attemt to move from section which doesnt belong to director before update.")
                        }
                        from = IndexPath(item: move.from.item, section: oldSectionIdx)
                    } else {
                        from = move.from
                    }

                    self.collectionView.moveItem(at: from, to: to)
                  }
                }
            }
            
            let sectionDeletes = sectionChanges.compactMap { $0.delete?.index }
            sectionDeletes.executeIfPresent { deletes in
                self.collectionView.deleteSections(IndexSet(deletes))
            }

            let sectionInserts = sectionChanges.compactMap { $0.insert?.index }
            sectionInserts.executeIfPresent { inserts in
                self.collectionView.insertSections(IndexSet(inserts))
            }

            sectionChanges.compactMap { $0.move }.executeIfPresent { moves in
                moves.forEach { self.collectionView.moveSection($0.fromIndex, toSection: $0.toIndex) }
            }
        }) { _ in
            completion?()
        }

        itemChanges.flatMap { $0.replaces }.executeIfPresent { [weak self] in
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
        createSnapshot()
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
        let item = section(for: indexPath.section).item(for: indexPath.row)
        if shouldUseAutomaticViewRegistration {
            viewsRegisterer.registerCellIfNeeded(reuseIdentifier: item.reuseIdentifier, cellClass: item.cellType)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
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
        
        let value = section_.headerItem?.estimatedSize(boundingSize: collectionView.bounds.size) ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section_ = sections[section]
        let value = section_.footerItem?.estimatedSize(boundingSize: collectionView.bounds.size) ?? .zero
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
            sections[indexPath.section].headerItem?.onDisplay?()
            break
        case UICollectionView.elementKindSectionFooter:
            sections[indexPath.section].footerItem?.onDisplay?()
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
            sections[indexPath.section].headerItem?.onEndDisplay?()
            break
        case UICollectionView.elementKindSectionFooter:
            sections[indexPath.section].footerItem?.onEndDisplay?()
            break
        default:
            break
        }
    }
}

//MARK:- UIScrollViewDelegate
extension CollectionDirector : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidScroll?(scrollView)
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
