//
//  CollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

open class CollectionSection : Equatable, Hashable {
    let identifier = UUID().uuidString
    open var items: [AbstractCollectionItem] = []
    open var headerItem: AbstractCollectionItem?
    open var footerItem: AbstractCollectionItem?
    
    var instetForSection: UIEdgeInsets = .zero
    var minimumInterItemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    var lineSpacing: CGFloat = 0

    public var hashValue: Int {
        return identifier.hashValue
    }

    open func append(item: AbstractCollectionItem) {
        items.append(item)
    }
    
    open func append(header: AbstractCollectionItem) {
        headerItem = header
    }
    
    open func append(footer: AbstractCollectionItem) {
        footerItem = footer
    }
    
    //TODO: include item to signature
    //TODO: add implementation
    func update(insertions: [Int], deletions: [Int], modifications: [Int]) {
        deletions.forEach(remove)
    }
    
    open func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.insertItem.rawValue : index ])
    }
    
    func remove(at index: Int) {
        items.remove(at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.removeItem.rawValue : index ])
    }
    
    public static func ==(lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    open func reload() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.reloadSection.rawValue),
                                        object: self)
    }
}

open class ExpandableSection: CollectionSection {
    open var collapsedItemsCount: Int
    open var isExpanded: Bool = false
    
    //TODO: consider pass isInitiallyExpanded paramater
    public init(collapsedItemsCount: Int) {
        self.collapsedItemsCount = collapsedItemsCount
    }
}
