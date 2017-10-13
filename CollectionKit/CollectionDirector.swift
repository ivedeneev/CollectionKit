//
//  ProductDetailDirector.swift
//  Marketplace
//
//  Created by Igor Vedeneev on 13.08.17.
//  Copyright © 2017 WeAreLT. All rights reserved.
//

import Foundation
import UIKit


//todo: consider delete this
enum CollectionSectionType {
    case common
    case expandaple
    case loadable
}



protocol ConfigurableCollectionItem : Reusable {
    associatedtype T
    static func estimatedSize(item: T?) -> CGSize
    func configure(item: T)
}

protocol ActionableCollectionItem {
    var onSelect: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onDeselect: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onDisplay: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onEndDisplay: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onHighlight: ((_ indexPath: IndexPath) -> Void)? { get set }
    var shouldHighlight: Bool? { get set }
}

extension UICollectionView {
    func dequeue<T: Reusable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerNib<T: Reusable>(_ type: T.Type) {
        self.register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerClass<T: Reusable>(_ type: T.Type) where T:UICollectionViewCell {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}


//MARK:- AbstractCollectionItem
protocol AbstractCollectionItem : ActionableCollectionItem {
    var reuseIdentifier: String { get }
    var estimatedSize: CGSize { get }
    func configure(_: UICollectionReusableView)
}


//MARK:- CollectionDirector
class CollectionDirector: NSObject {
    var sections: [CollectionSection] = []
    fileprivate weak var collectionView: UICollectionView!
    
    init(colletionView: UICollectionView) {
        self.collectionView = colletionView
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReload),
                                               name: Notification.Name(rawValue: NotificationNames.reloadSection.rawValue),
                                               object: nil)
    }
    
    @objc private func handleReload(notification: Notification) {
        guard let section = notification.object as? CollectionSection, let idx = self.sections.index(where: {$0 == section}) else { return }
        self.collectionView.performBatchUpdates({ [unowned self] in
            self.collectionView.reloadSections([idx])
        }, completion: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func append(section: CollectionSection) {
        self.sections.append(section)
    }
    
    func reload(section: CollectionSection) {
        guard let idx = sections.index(where: {$0 == section}) else {return}
        
//        let range = section.collapsedItemsCount..<section.items.count
//        let indexPaths = range.map({IndexPath(item: $0, section: idx)})
//        
//        if section.type == .expandaple && section.isExpanded {
//            self.collectionView.performBatchUpdates({ [weak collectionView] in
//                guard let strongCollectionView = collectionView else {return}
//                strongCollectionView.insertItems(at: indexPaths)
//                }, completion: nil)
//        } else {
//            self.collectionView.performBatchUpdates({ [weak collectionView] in
//                guard let strongCollectionView = collectionView else {return}
//                strongCollectionView.deleteItems(at: indexPaths)
//                }, completion: nil)
//        }
    }
    
    func setNeedsUpdate() {
        self.collectionView.performBatchUpdates({}, completion: nil)
    }
    
    func reloadLoadableSection(section: CollectionSection) {
//        guard let idx = sections.index(where: {$0 == section}) else {return}
//        self.collectionView.performBatchUpdates({ [weak collectionView] in
//            guard let strongCollectionView = collectionView else {return}
//            strongCollectionView.reloadSections([idx])
//            }, completion: nil)
    }
    
    fileprivate func shouldLoadRelated(indexPath: IndexPath) -> Bool {
        let isSellerSection = indexPath.section == sections.count - 2
        return isSellerSection
    }
    
    //TODO: remove header/footer
    //TODO: expansion
}


//MARK:- UICollectionViewDataSource
extension CollectionDirector: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionObject = sections[section]
        
        if let expandableSection = sectionObject as? ExpandableSection, let collappsedItemsCount = expandableSection.collapsedItemsCount {
            return expandableSection.isExpanded ? sectionObject.items.count : min(collappsedItemsCount, expandableSection.items.count)
        }
        
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        item.onSelect?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        item.onDeselect?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        item.onDisplay?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        item.onEndDisplay?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].items[indexPath.row]
        return item.estimatedSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].instetForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section_ = sections[section]
        let value = section_.headerItem?.estimatedSize ?? CGSize(width: collectionView.bounds.width, height: section_.headerHeight)
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section_ = sections[section]        
        let value = section_.footerItem?.estimatedSize ?? CGSize(width: collectionView.bounds.width, height: section_.footerHeight)
        return value
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].lineSpacing
    }
}

