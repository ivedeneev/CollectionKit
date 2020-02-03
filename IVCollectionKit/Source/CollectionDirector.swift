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
    private var isUpdating = false
    
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
        //TODO: refactor
        updateSectionIds()
        updateLastCommitedIdentifiers()
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

    public func setNeedsUpdate() {
        collectionView.performBatchUpdates({}, completion: nil)
    }
    
    private func updateSectionIds() {
        sectionIds = sections.map { $0.identifier }
    }
    
    /// Calculates and performs managed UICollectionView updates based on diff between sections array state
    /// afert last update or reload and current state
    /// if `UICollectionView` is empty performs reload inseted of batch updates to prevent crash
    /// - parameter completion: closure, which will be called after all updates has been performed. Nullable
    ///
    public func performUpdates(completion: (() -> Void)? = nil) {
        let newSectionIds = self.sections.map { $0.identifier }
        let oldSectionIds = sectionIds
        let sectionDiff = diff(old: oldSectionIds, new: newSectionIds)
        
        if oldSectionIds.isEmpty {
            reload()
            return
        }

        var deletes: [(Delete<String>, IndexPath)] = []
        var inserts: [(Insert<String>, IndexPath)] = []
        var reloads: [(Replace<String>, IndexPath)] = []
        var moves: [(IndexPath, IndexPath)] = []
        
//        var sectionMoves: [(IndexPath, IndexPath)] = []
        
        self.sections.enumerated().forEach { (idx, section) in
            let oldSectionIds = self.lastCommitedSectionAndItemsIdentifiers[section.identifier] ?? section.currentItemIds()
            let diff_ = diff(old: oldSectionIds, new: section.currentItemIds())
            let d = diff_.compactMap { $0.delete }.map { ($0, IndexPath(row: $0.index, section: idx)) }
            let i = diff_.compactMap { $0.insert }.map { ($0, IndexPath(row: $0.index, section: idx)) }
            let r = diff_.compactMap { $0.replace }.map { ($0, IndexPath(row: $0.index, section: idx)) }
            let m = diff_.compactMap { $0.move }.map { (IndexPath(row: $0.fromIndex, section: idx), IndexPath(row: $0.toIndex, section: idx)) }
            
            deletes.append(contentsOf: d)
            inserts.append(contentsOf: i)
            reloads.append(contentsOf: r)
            moves.append(contentsOf: m)
        }
        
        if deletes.isEmpty && inserts.isEmpty && reloads.isEmpty && sectionDiff.isEmpty && moves.isEmpty {
             completion?()
             isUpdating = false
             return
        }
    
        deletes.forEach { del in
            guard let idx = deletes.firstIndex(where: { $0.0.item == del.0.item }),
                let ins = inserts.firstIndex(where: { $0.0.item == del.0.item })
                else { return }
            
            let toIp = inserts[ins].1
            let fromIp = del.1
            // Check if director contained section before update.
            // If it dosent all animations will be discareded and reload data will be called
            
            deletes.remove(at: idx)
            inserts.remove(at: ins)
            moves.append((fromIp, toIp))
        }
        self.updateSectionIds()
        self.updateLastCommitedIdentifiers()
    
    
//        if sectionDiff.count > 0 && (deletes.count > 0 || moves.count > 0 || inserts.count > 0) || (sectionDiff.compactMap { $0.move }.count > 0) {
//            collectionView.reloadData()
//            completion?()
//            isUpdating = false
//            return
//        }
        
        collectionView.performBatchUpdates({ [weak self] in
            guard let `self` = self else { return }
            
            let dels = deletes.filter { $0.1.section < self.collectionView.numberOfSections }
                .filter { $0.1.item < self.collectionView.numberOfItems(inSection: $0.1.section) }
            dels.map { $0.0 }.executeIfPresent { _ in
                    self.collectionView.deleteItems(at: dels.map { $1 })
                }
            
            inserts.map { $0.0 }.executeIfPresent { _ in
                self.collectionView.insertItems(at: inserts.map { $1 })
            }
            
            reloads.executeIfPresent { [unowned self] _ in
                let array = reloads.map { $1 }
                self.collectionView.reloadItems(at: array)
            }
            
            moves.executeIfPresent {
                $0.forEach { move in
                    let sectionId = newSectionIds[move.0.section]
                    guard let oldSectionNumber = oldSectionIds.firstIndex(of: sectionId) else {
                        let errorMsg = "Attemt to move from section which doesnt belong to director before update."
                        fatalError(errorMsg)
                    }
                    let from = IndexPath(row: move.0.row, section: oldSectionNumber)
                    let to = move.1
                    self.collectionView.moveItem(at: from, to: to)
                }
            }
            
            //todo: sort
            let sectionDeletes = sectionDiff.compactMap { $0.delete?.index }
            sectionDeletes.executeIfPresent({ (deletes) in
                self.collectionView.deleteSections(IndexSet(deletes))
            })
            //todo: sort
            let sectionInserts = sectionDiff.compactMap { $0.insert?.index }
            sectionInserts.executeIfPresent({ (inserts) in
                self.collectionView.insertSections(IndexSet(inserts))
            })
            sectionDiff.compactMap { $0.move }.executeIfPresent({ (moves) in
                moves.forEach { self.collectionView.moveSection($0.fromIndex, toSection: $0.toIndex) }
                
            })
            
        }) { [weak self] _ in
            completion?()
            self?.isUpdating = false
        }
    }
    
    private func updateLastCommitedIdentifiers() {
        lastCommitedSectionAndItemsIdentifiers = [:]

        for s in sections {
            lastCommitedSectionAndItemsIdentifiers[s.identifier] = s.currentItemIds()
        }
    }
    
    open override func responds(to selector: Selector) -> Bool {
        return super.responds(to: selector) || scrollDelegate?.responds(to: selector) == true
    }
    
    open override func forwardingTarget(for selector: Selector) -> Any? {
        return scrollDelegate?.responds(to: selector) == true ? scrollDelegate : super.forwardingTarget(for: selector)
    }
}

//MARK:- Public
extension CollectionDirector {
    public func removeAll(clearSections: Bool = false) {
        if clearSections {
            sections.forEach { $0.removeAll() }
        }
        
        sections.removeAll()
    }
}

//MARK:- UICollectionViewDataSource
extension CollectionDirector: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems()
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].item(for: indexPath.row)
        if shouldUseAutomaticViewRegistration {
            viewsRegisterer.registerCellIfNeeded(reuseIdentifier: item.reuseIdentifier, cellClass: item.cellType)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]

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

//MARK:- UICollectionViewDataSource
extension CollectionDirector : UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].didSelectItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        sections[indexPath.section].didDeselectItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sections[indexPath.section].willDisplayItem(at: indexPath, cell: cell)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard sections.count > indexPath.section,
            sections[indexPath.section].numberOfItems() > indexPath.row else { return }
        
        sections[indexPath.section].didEndDisplayingItem(at: indexPath, cell: cell)
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        sections[indexPath.section].shouldHighlightItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        sections[indexPath.section].didHighlightItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        sections[indexPath.section].didUnhighlightItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        
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
        return sections[section].insetForSection
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section_ = sections[section]
        
        let value = section_.headerItem?.estimatedSize(boundingSize: collectionView.bounds.size) ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section_ = sections[section]
        let value = section_.footerItem?.estimatedSize(boundingSize: collectionView.bounds.size) ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumInterItemSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard sections.indices.contains(indexPath.section) else { return }
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
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard indexPath.count > 0 else { return }
        guard sections.indices.contains(indexPath.section) else { return }
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

//MARK:- Insertions
extension CollectionDirector {
    public func append(section: AbstractCollectionSection) {
        sections.append(section)
    }
    
    public func insert(section: AbstractCollectionSection, after afterSection: AbstractCollectionSection) {
        guard let afterIndex = sections.firstIndex(where: { section == $0 }) else { return }
        sections.insert(section, at: afterIndex + 1)
    }
    
    public func insert(section: AbstractCollectionSection, at index: Int) {
        sections.insert(section, at: index)
    }
    
    public func append(sections: [AbstractCollectionSection]) {
        self.sections.append(contentsOf: sections)
    }
}

//MARK:- UIScrollViewDelegate
extension CollectionDirector : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
}
