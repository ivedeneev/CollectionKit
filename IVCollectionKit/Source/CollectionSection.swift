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

    public var items: [AbstractCollectionItem] = []
    public var headerItem: AbstractCollectionHeaderFooterItem?
    public var footerItem: AbstractCollectionHeaderFooterItem?
    
    open var insetForSection: UIEdgeInsets = .zero
    open var minimumInterItemSpacing: CGFloat = .leastNormalMagnitude
    open var lineSpacing: CGFloat = 0

    public init(id: String = UUID().uuidString, items: [AbstractCollectionItem] = []) {
        self.items = items
        self.identifier = id
    }
    
    public func cell(for director: CollectionDirector, indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = director.private_dequeueReusableCell(of: item.cellType, reuseIdentifier: item.reuseIdentifier, for: indexPath)
        item.configure(cell)
        
        return cell
    }
    
    public func numberOfItems() -> Int {
        return items.count
    }
    
    public func currentItemIds() -> [String] {
        return items.map { $0.identifier }
    }

    public func append(item: AbstractCollectionItem) {
        items.append(item)
    }
    
    public func append(items: [AbstractCollectionItem]) {
        self.items.append(contentsOf: items)
    }
    
    public func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
    }
    
    public func removeAll() {
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
        return items[indexPath.item].shouldHighlight
    }
    
    open func didHighlightItem(at indexPath: IndexPath) {
         items[indexPath.item].onHighlight?(indexPath)
    }
    
    open func didUnhighlightItem(at indexPath: IndexPath) {
         items[indexPath.item].onUnighlight?(indexPath)
    }
    
    open func sizeForItem(at indexPath: IndexPath, boundingSize: CGSize) -> CGSize {
        return items[indexPath.item].estimatedSize(boundingSize: boundingSize, in: self)
    }
    
    public func itemAdjustsWidth(at index: Int) -> Bool {
        guard !isEmpty else { return false }
        return items[index].adjustsWidth
    }
    
    public func itemAdjustsHeight(at index: Int) -> Bool {
        guard !isEmpty else { return false }
        return items[index].adjustsHeight
    }
    
    public func shouldSelect(at indexPath: IndexPath) -> Bool {
        return items[indexPath.row].shouldSelect
    }
    
    public func shouldDeselect(at indexPath: IndexPath) -> Bool {
        return items[indexPath.row].shouldDeselect
    }
}
