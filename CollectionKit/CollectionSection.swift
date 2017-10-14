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
    var headerItem: AbstractCollectionItem?
    var footerItem: AbstractCollectionItem?
    
    var instetForSection: UIEdgeInsets = .zero
    var minimumInterItemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    var lineSpacing: CGFloat = 0

    public var hashValue: Int {
        return identifier.hashValue
    }

    func append(item: AbstractCollectionItem) {
        items.append(item)
    }
    
    func append(header: AbstractCollectionItem) {
        headerItem = header
    }
    
    func append(footer: AbstractCollectionItem) {
        footerItem = footer
    }
    
    func update(insertions: [Int], deletions: [Int], modifications: [Int]) {
        
    }
    
    func insert(item: AbstractCollectionItem, at index: Int) {
        items.insert(item, at: index)
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.sectionChanges.rawValue),
                                        object: self,
                                        userInfo: [ CollectionChange.insertItem.rawValue : index ])
    }
    
    func remove(at index: Int) {
        items.remove(at: index)
    }
    
    public static func ==(lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func reload() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.reloadSection.rawValue),
                                        object: self)
    }
}

class ExpandableSection: CollectionSection {
    var collapsedItemsCount: Int
    var isExpanded: Bool = false
    
    //todo: consider pass isInitiallyExpanded paramater
    init(collapsedItemsCount: Int) {
        self.collapsedItemsCount = collapsedItemsCount
    }
}
