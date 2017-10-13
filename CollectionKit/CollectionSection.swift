//
//  CollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

class CollectionSection : Equatable, Hashable {
    let identifier = UUID().uuidString
    var items: [AbstractCollectionItem] = []
    var headerItem: AbstractCollectionItem?
    var footerItem: AbstractCollectionItem?
    
    var headerHeight: CGFloat = 0
    var footerHeight: CGFloat = 0
    var title: String?
    var type: CollectionSectionType
    var instetForSection: UIEdgeInsets = .zero
    var minimumInterItemSpacing: CGFloat = CGFloat.leastNormalMagnitude
    var lineSpacing: CGFloat = 0
    //todo: refactor this
    var isLoading: Bool = true
    /////// only for expandable Sections
    
    //////
    
    var hashValue: Int {
        return identifier.hashValue
    }
    
    init(title: String? = nil, type: CollectionSectionType = .common) {
        self.title = title
        self.type = type
    }
    
    func append(item: AbstractCollectionItem) {
        items.append(item)
    }
    
    func append(header: AbstractCollectionItem) {
        headerItem = header
        headerHeight = header.estimatedSize.height
    }
    
    func append(footer: AbstractCollectionItem) {
        footerItem = footer
        footerHeight = footer.estimatedSize.height
    }
    
    static func ==(lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func reload() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.reloadSection.rawValue), object: self)
    }
}

class ExpandableSection: CollectionSection {
    var collapsedItemsCount: Int?
    var isExpanded: Bool = false
}
