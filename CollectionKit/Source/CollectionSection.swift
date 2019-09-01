//
//  CollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

open class CollectionSection : AbstractCollectionSection {
    
    public let identifier: String = UUID().uuidString

    open var items: [AbstractCollectionItem] = []
    open var headerItem: AbstractCollectionHeaderFooterItem?
    open var footerItem: AbstractCollectionHeaderFooterItem?
    
    open var insetForSection: UIEdgeInsets = .zero
    open var minimumInterItemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    open var lineSpacing: CGFloat = 0
    
    public init() {}
    
    public required init(items: [AbstractCollectionItem]) {
        self.items = items
    }
    
    open func item(for index: Int) -> AbstractCollectionItem {
        return items[index]
    }
    
    open func numberOfItems() -> Int {
        return items.count
    }

    open func append(item: AbstractCollectionItem) {
        items.append(item)
        postInsertOrDeleteItemNotification(section: self, indicies: [ items.count - 1 ], action: .insert)
    }

    public func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
        postInsertOrDeleteItemNotification(section: self, indicies: [ index ], action: .insert)
    }
    
    public func append(items: [AbstractCollectionItem]) {
        self.items.append(contentsOf: items)
        let oldCount = self.items.count - items.count - 1
        let indicies = Array(oldCount..<self.items.count)
        postInsertOrDeleteItemNotification(section: self, indicies: indicies, action: .insert)
    }
    
    public func insert(items: [AbstractCollectionItem], at indicies: [Int]) {
        //TODO: check for correct indicies
        for i in 0..<items.count {
            self.items.insert(items[i], at: indicies[i])
        }
        postInsertOrDeleteItemNotification(section: self, indicies: indicies, action: .insert)
    }
    
    public func remove(at index: Int) {
        //todo: consider more correct condition
        guard index < items.count else { return }
        items.remove(at: index)
        postInsertOrDeleteItemNotification(section: self, indicies: [ index ], action: .delete)
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
            guard let index = self.items.firstIndex(where: { $0.identifier == item.identifier }) else {
                log("Attempt to delete item , which is not contained at section", logLevel: .error)
                return
            }
            self.items.remove(at: index)
        }
    }
    
    public func remove(at indicies: [Int]) {
        items.remove(at: indicies)
        postInsertOrDeleteItemNotification(section: self, indicies: indicies, action: .delete)
    }
    
    open func reload() {
        postReloadNotofication(subject: .section, object: self)
    }
    
    public func reload(with reloadItems: [AbstractCollectionItem]) {
        self.items.removeAll()
        self.items.append(contentsOf: reloadItems)
        reload()
    }
    
    public func clear() {
        let indicies = Array(0..<items.count)
        items.removeAll()
        postInsertOrDeleteItemNotification(section: self, indicies: indicies, action: .delete)
    }
    
    public func contains(item: AbstractCollectionItem) -> Bool {
        return items.contains(where: {$0 == item})
    }
    
    public func index(for item: AbstractCollectionItem) -> Int? {
        return items.firstIndex(where: {$0 == item})
    }
}
