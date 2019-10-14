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
    
    public init(id: String = UUID().uuidString) {
        self.identifier = id
    }
    
    public required init(id: String = UUID().uuidString, items: [AbstractCollectionItem]) {
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

    public func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
    }
    
    public func append(items: [AbstractCollectionItem]) {
        self.items.append(contentsOf: items)
    }
    
    public func insert(items: [AbstractCollectionItem], at indicies: [Int]) {
        //TODO: check for correct indicies
        for i in 0..<items.count {
            self.items.insert(items[i], at: indicies[i])
        }
    }
    
    public func remove(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
    }
    
    public func remove(item: AbstractCollectionItem) {
        guard let index = items.firstIndex(where: { $0 == item }) else {
            log("Attempt to remove item from section, which it doesnt belongs to", logLevel: .error)
            return
        }
        
        remove(at: index)
    }
    
    public func remove(items: [AbstractCollectionItem]) {
        items.forEach { [weak self] (item) in
            guard let `self` = self else { return }
            guard let index = self.items.firstIndex(where: { $0 == item }) else {
                log("Attempt to delete item , which is not contained at section", logLevel: .error)
                return
            }
            self.items.remove(at: index)
        }
    }
    
    public func remove(at indicies: [Int]) {
        items.remove(at: indicies)
    }
    
    public func reload(with reloadItems: [AbstractCollectionItem]) {
        items.removeAll()
        items.append(contentsOf: reloadItems)
        reload()
    }
    
    public func removeAll() {
        items.removeAll()
    }
    
    public func contains(item: AbstractCollectionItem) -> Bool {
        return items.contains(where: {$0 == item})
    }
    
    public func index(for item: AbstractCollectionItem) -> Int? {
        return items.firstIndex(where: {$0 == item})
    }
}
