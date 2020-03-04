//
//  CollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

/// Class represents `UICollectionView` section model.
/// It contains models for each cell in section, models for header and footer
/// Also it contains values for `insetForSection`, `minimumInterItemSpacing` and `lineSpacing`
open class CollectionSection : AbstractCollectionSection {

    public let identifier: String

    open var items: [AbstractCollectionItem] = []
    open var headerItem: AbstractCollectionHeaderFooterItem?
    open var footerItem: AbstractCollectionHeaderFooterItem?
    
    open var insetForSection: UIEdgeInsets = .zero
    open var minimumInterItemSpacing: CGFloat = .leastNormalMagnitude
    open var lineSpacing: CGFloat = 0

    public init(id: String = UUID().uuidString, items: [AbstractCollectionItem] = []) {
        self.items = items
        self.identifier = id
    }
    
    open func item(for index: Int) -> AbstractCollectionItem {
        return items[index]
    }
    
    open func numberOfItems() -> Int {
        return items.count
    }
    
    open func currentItemIds() -> [String] {
        return items.map { $0.identifier }
    }

    open func append(item: AbstractCollectionItem) {
        items.append(item)
    }
    
    open func append(items: [AbstractCollectionItem]) {
        self.items.append(contentsOf: items)
    }
    
    open func removeAll() {
        items.removeAll()
    }
    
    open func willDisplayItem(at indexPath: IndexPath, cell: UICollectionViewCell) {
        items[indexPath.item].onDisplay?(indexPath, cell)
    }
    
    open func didEndDisplayingItem(at indexPath: IndexPath, cell: UICollectionViewCell) {
         items[indexPath.item].onEndDisplay?(indexPath, cell)
    }
    
    open func didSelectItem(at indexPath: IndexPath) {
         items[indexPath.item].onSelect?(indexPath)
    }
    
    open func didDeselectItem(at indexPath: IndexPath) {
        items[indexPath.item].onDeselect?(indexPath)
    }
    
    open func shouldHighlightItem(at indexPath: IndexPath) -> Bool {
        return items[indexPath.item].shouldHighlight ?? true
    }
    
    open func didHighlightItem(at indexPath: IndexPath) {
         items[indexPath.item].onHighlight?(indexPath)
    }
    
    open func didUnhighlightItem(at indexPath: IndexPath) {
         items[indexPath.item].onUnighlight?(indexPath)
    }
    
    open func sizeForItem(at indexPath: IndexPath, boundingSize: CGSize) -> CGSize {
        return items[indexPath.item].estimatedSize(boundingSize: boundingSize)
    }
    
    open func itemAdjustsWidth(at index: Int) -> Bool {
        guard !isEmpty else { return false }
        return items[index].adjustsWidth
    }
    
    open func itemAdjustsHeight(at index: Int) -> Bool {
        guard !isEmpty else { return false }
        return items[index].adjustsHeight
    }
}
