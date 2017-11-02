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
 5. автоматическая регистрация ячеек/хедеров/футеров
 6. logging
 */
//MARK:- CollectionDirector
open class CollectionDirector: NSObject {
    fileprivate weak var collectionView: UICollectionView!
    open var sections = [AbstractCollectionSection]()
    private var reuseIdentifiers: Set<String> = []
    open var shouldUseAutomaticCellRegistration: Bool = false
    
    public init(colletionView: UICollectionView) {
        self.collectionView = colletionView
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleSectionReload),
                                               name: Notification.Name(rawValue: NotificationNames.reloadSection.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInsert),
                                               name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleItemReload),
                                               name: Notification.Name(rawValue: NotificationNames.reloadRow.rawValue),
                                               object: nil)
    }
    
    @objc private func handleItemReload(notification: Notification) {
        guard let item = notification.object as? AbstractCollectionItem,
            let sectionIdx = sections.index(where: {$0.contains(item: item)}),
            let itemIndex = sections[sectionIdx].index(for: item) else { return }
        self.collectionView.performBatchUpdates({ [unowned self] in
            let indexPath = IndexPath(item: itemIndex, section: sectionIdx)
            self.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
    }
    
    @objc private func handleSectionReload(notification: Notification) {
        guard let section = notification.object as? CollectionSection,
            let idx = self.sections.index(where: {$0.identifier == section.identifier}) else { return }
        self.collectionView.performBatchUpdates({ [unowned self] in
            self.collectionView.reloadSections([idx])
            }, completion: nil)
    }
    
    @objc private func handleInsert(notification: Notification) {
        guard let section = notification.object as? CollectionSection, let sectionIndex = self.sections.index(where: {$0.identifier == section.identifier}) else { return }
        var insert = [IndexPath]()
        var delete = [IndexPath]()
        var reload = [IndexPath]()
        
        if let insertedItemIndex = notification.userInfo?[CollectionChange.insertItem.rawValue] as? Int {
            insert.append(IndexPath(item: insertedItemIndex, section: sectionIndex))
        }
        
        if let deletedItemIndex = notification.userInfo?[CollectionChange.removeItem.rawValue] as? Int {
            delete.append(IndexPath(item: deletedItemIndex, section: sectionIndex))
        }
        
        if let reloadItemIndex = notification.userInfo?[CollectionChange.reloadItem.rawValue] as? Int {
            reload.append(IndexPath(item: reloadItemIndex, section: sectionIndex))
        }
        
        self.collectionView.performBatchUpdates({ [unowned self] in
            self.collectionView.insertItems(at: insert)
            self.collectionView.deleteItems(at: delete)
            self.collectionView.reloadItems(at: reload)
        }, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func append(section: CollectionSection) {
        self.sections.append(section)
    }
    
    open func reload() {
        collectionView.reloadData()
    }

    open func setNeedsUpdate() {
        self.collectionView.performBatchUpdates({}, completion: nil)
    }
    
    open func insert(section: AbstractCollectionSection, after afterSection: AbstractCollectionSection) {
        guard let afterIndex = sections.index(where: { section == $0 }) else { return }
        sections.insert(section, at: afterIndex + 1)
    }
    
    open func insert(section: AbstractCollectionSection, at index: Int) {
        sections.insert(section, at: index)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let header = section.headerItem else { return UICollectionReusableView() }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.reuseIdentifier, for: indexPath)
            header.configure(headerView)
            return headerView
        case UICollectionElementKindSectionFooter:
            guard let footer = section.footerItem else { return UICollectionReusableView() }
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
        item.onDisplay?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //FIXME: crash when deleting last row
        guard sections.count > indexPath.section, sections[indexPath.section].numberOfItems() > indexPath.row else { return }
        let item = sections[indexPath.section].item(for: indexPath.row)
        item.onEndDisplay?(indexPath)
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
        let item = sections[indexPath.section].item(for: indexPath.row)
        return item.estimatedSize
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].insetForSection
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section_ = sections[section]
        let value = section_.headerItem?.estimatedSize ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section_ = sections[section]        
        let value = section_.footerItem?.estimatedSize ?? .zero
        return value
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumInterItemSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].lineSpacing
    }
}
