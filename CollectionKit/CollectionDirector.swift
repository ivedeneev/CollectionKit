//
//  ProductDetailDirector.swift
//  Marketplace
//
//  Created by Igor Vedeneev on 13.08.17.
//  Copyright © 2017 WeAreLT. All rights reserved.
//

import Foundation
import UIKit


/*
 1  потестить обновления
 2  потестить с реалмом и кор датой
 3. удаление/добавления хедеры/футеры
 4. автоматическая ширина по ширине экрана
 5. автоматическая регистрация хедеров/футеров, также вынести регистрацию в отдельный класс/метод
 6. logging
 8. определение уникальности ячейки/секции
 9. потестить со сторибордами/ксибами/кастомными reuseIdentifiers
 */

//MARK:- CollectionDirector
open class CollectionDirector: NSObject {
    public var sections = [AbstractCollectionSection]()
    open var shouldUseAutomaticViewRegistration: Bool = false
    ///Adjust z position for headers/footers to prevent scroll indicator hiding at iOS11
    open var shouldAdjustSupplementaryViewLayerZPosition: Bool = true
    open weak var scrollDelegate: UIScrollViewDelegate?
    
    private weak var collectionView: UICollectionView!
    private var disableUpdates: Bool = false
    private var deferBatchUpdates: Bool = false
    private lazy var updater = CollectionUpdater(collectionView: self.collectionView)
    private var deferredUpdates: [AbstractCollectionUpdate] = []
    private lazy var viewsRegisterer = CollectionReusableViewsRegisterer(collectionView: self.collectionView)
    
    public init(colletionView: UICollectionView) {
        self.collectionView = colletionView
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func remove(section: AbstractCollectionSection) {
        guard let index = sections.index(where: { $0.identifier == section.identifier }) else {
            log("attempt to remove section not @ director", logLevel: .warning)
            return
            
        }
        sections.remove(at: index)
        let update = SectionUpdate(index: index, type: .delete)
        deferredUpdates.append(update)
    }
    
    public func removeSection(at index: Int) {
        sections.remove(at: index)
        let update = SectionUpdate(index: index, type: .delete)
        deferredUpdates.append(update)
    }
    
    //todo: add/remove array of sections
    
    public func reload() {
        collectionView.reloadData()
    }

    public func setNeedsUpdate() {
        self.collectionView.performBatchUpdates({}, completion: nil)
    }
    
    public func performUpdates(updates: (() -> Void), completion: (() -> Void)? = nil) {
        deferredUpdates.removeAll()
        updates()
        commitUpdates(completion: completion)
    }
    
    private func commitUpdates(completion: (() -> Void)? = nil) {
        collectionView.performBatchUpdates({ [unowned self] in
            self.updater.apply(changes: self.deferredUpdates)
        }) { [unowned self] (finished) in
            guard finished else { return }
            self.deferredUpdates.removeAll()
            completion?()
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
        case UICollectionElementKindSectionHeader:
            guard let header = section.headerItem else { return UICollectionReusableView() }
            if shouldUseAutomaticViewRegistration {
                viewsRegisterer.registerHeaderFooterViewIfNeeded(reuseIdentifier: header.reuseIdentifier, viewClass: header.viewType, kind: kind)
            }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.reuseIdentifier, for: indexPath)
            header.configure(headerView)
            return headerView
        case UICollectionElementKindSectionFooter:
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
        let item = sections[indexPath.section].item(for: indexPath.row)
        item.onSelect?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].item(for: indexPath.row)
        item.onDeselect?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].item(for: indexPath.row)
        item.onDisplay?(indexPath, cell)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard sections.count > indexPath.section,
            sections[indexPath.section].numberOfItems() > indexPath.row else { return }
        let item = sections[indexPath.section].item(for: indexPath.row)
        item.onEndDisplay?(indexPath, cell)
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let item = sections[indexPath.section].item(for: indexPath.row)
        //TODO: consider false as default value or set default value in colection item
        return item.shouldHighlight ?? true
    }
    
    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].item(for: indexPath.row)
        item.onHighlight?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].item(for: indexPath.row)
        item.onUnighlight?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        let item = section.item(for: indexPath.row)
        var size = item.estimatedSize(collectionViewSize: collectionView.bounds.size)
        let inset = section.insetForSection
        if item.autoSizedWidth {
            let width = max(size.width, collectionView.bounds.width - (inset.left + inset.right))
            size.width = width
        }
        
        if item.autoSizedHeight {
            let width = max(size.height, collectionView.bounds.height - (inset.bottom + inset.top))
            size.width = width
        }
        
        return size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].insetForSection
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section_ = sections[section]
        
        let value = section_.headerItem?.estimatedSize(collectionViewSize: collectionView.bounds.size) ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section_ = sections[section]        
        let value = section_.footerItem?.estimatedSize(collectionViewSize: collectionView.bounds.size) ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumInterItemSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            sections[indexPath.section].headerItem?.onDisplay?()
            break
        case UICollectionElementKindSectionFooter:
            sections[indexPath.section].footerItem?.onDisplay?()
            break
        default:
            break
        }
        
        guard shouldAdjustSupplementaryViewLayerZPosition, #available(iOS 11.0, *) else { return }
        view.layer.zPosition = 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            sections[indexPath.section].headerItem?.onEndDisplay?()
            break
        case UICollectionElementKindSectionFooter:
            sections[indexPath.section].footerItem?.onEndDisplay?()
            break
        default:
            break
        }
    }
}


//MARK:- Private
extension CollectionDirector {
    func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReload),
                                               name: Notification.Name(rawValue: CKReloadNotificationName),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInsertOrDelete),
                                               name: Notification.Name(rawValue: CKInsertOrDeleteNotificationName),
                                               object: nil)
    }
}

//MARK:- Insertions
extension CollectionDirector {
    public func append(section: AbstractCollectionSection) {
        sections.append(section)
        let update = SectionUpdate(index: sections.count - 1, type: .insert)
        deferredUpdates.append(update)
    }
    public func insert(section: AbstractCollectionSection, after afterSection: AbstractCollectionSection) {
        guard let afterIndex = sections.index(where: { section == $0 }) else { return }
        sections.insert(section, at: afterIndex + 1)
        let update = SectionUpdate(index: afterIndex + 1, type: .insert)
        deferredUpdates.append(update)
    }
    
    public func insert(section: AbstractCollectionSection, at index: Int) {
        sections.insert(section, at: index)
        let update = SectionUpdate(index: index, type: .insert)
        deferredUpdates.append(update)
    }
}

//MARK:- Updates handling
private extension CollectionDirector {
    @objc private func handleReload(notification: Notification) {
        guard let subject = notification.userInfo?[CKUpdateSubjectKey] as? UpdateSubject else { return }
        switch subject {
        case .item:
            guard let item = notification.object as? AbstractCollectionItem else { return }
            guard let sectionIndex = sections.index(where: { $0.contains(item: item) }) else { return }
            guard let itemIndex = sections[sectionIndex].index(for: item) else { return }
            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
            let update = ItemUpdate(indexPath: indexPath, type: .reload)
            deferredUpdates.append(update)
            break
        case .section:
            guard let section = notification.object as? AbstractCollectionSection,
                let index = sections.index(where: { $0 == section }) else { return }
            
            let update = SectionUpdate(index: index, type: .reload)
            deferredUpdates.append(update)
            break
        }
    }
    
    @objc private func handleInsertOrDelete(notification: Notification) {
        guard let action = notification.userInfo?[CKUpdateActionKey] as? UpdateActionType,
            let section = notification.userInfo?[CKTargetSectionKey] as? AbstractCollectionSection,
            let itemIndicies = notification.userInfo?[CKItemIndexKey] as? [Int] else { return }
        
        guard let sectionIndex = sections.index(where: { $0.identifier == section.identifier }) else { return }
        
        let indexPaths = itemIndicies.map { IndexPath(item: $0, section: sectionIndex) }
        let update = ItemUpdate(indexPaths: indexPaths, type: action)
        deferredUpdates.append(update)
    }
}

//MARK:- UIScrollViewDelegate
extension CollectionDirector : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
}
