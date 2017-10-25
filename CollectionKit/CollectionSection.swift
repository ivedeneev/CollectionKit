//
//  CollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

open class CollectionSection : Equatable, Hashable {
    private let identifier = UUID().uuidString
    open var items: [AbstractCollectionItem] = []
    open var headerItem: AbstractCollectionItem?
    open var footerItem: AbstractCollectionItem?
    
    open var instetForSection: UIEdgeInsets = .zero
    open var minimumInterItemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    open var lineSpacing: CGFloat = 0
    
    public init() {}

    public var hashValue: Int { return identifier.hashValue }

    public func append(item: AbstractCollectionItem) {
        items.append(item)
    }
    
    //TODO: include item to signature
    //TODO: add implementation
    public func update(insertions: [Int], deletions: [Int], modifications: [Int]) {
        deletions.forEach(remove)
    }
    
    public func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.insertItem.rawValue : index ])
    }
    
    public func remove(at index: Int) {
        items.remove(at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.removeItem.rawValue : index ])
    }
    
    public static func ==(lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func reload() {
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
