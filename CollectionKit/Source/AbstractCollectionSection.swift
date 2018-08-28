//
//  AbstractCollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 09.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation

//todo: добавть equals и перенести все методы по работе с секцией в протокол, добавить в ридми про абстрактные секции
public protocol AbstractCollectionSection : class {
    var identifier: String { get }
    var headerItem: AbstractCollectionHeaderFooterItem? { get set }
    var footerItem: AbstractCollectionHeaderFooterItem? { get set }
    
    var insetForSection: UIEdgeInsets { get set }
    var minimumInterItemSpacing: CGFloat { get set }
    var lineSpacing: CGFloat { get set }
    
    var isEmpty: Bool { get }
    
    func numberOfItems() -> Int
    func item(for index: Int) -> AbstractCollectionItem
    func contains(item: AbstractCollectionItem) -> Bool
    func index(for item: AbstractCollectionItem) -> Int?
    
    func append(item: AbstractCollectionItem)
    func append(items: [AbstractCollectionItem])
    
    func insert(item: AbstractCollectionItem, at index: Int)
    func insert(items: [AbstractCollectionItem], at indicies: [Int])
    
    func remove(at index: Int)
    func remove(item: AbstractCollectionItem)
    func remove(items: [AbstractCollectionItem])
    func remove(at indicies: [Int])
    
    func clear()
    func reload()
    
    init(items: [AbstractCollectionItem])
}

extension AbstractCollectionSection {
    public var isEmpty: Bool { return numberOfItems() == 0 }
    
    public func reload() {
        postReloadNotofication(subject: .section, object: self)
    }
}
