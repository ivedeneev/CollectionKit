//
//  CollectionItem.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

//как то различать ячейки и хедеры/футеры
open class CollectionItem<CellType: ConfigurableCollectionItem>: AbstractCollectionItem where CellType: UICollectionViewCell {
    
    open var onSelect: ((_ indexPath: IndexPath) -> Void)?
    open var onDeselect: ((_ indexPath: IndexPath) -> Void)?
    open var onDisplay: ((_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void)?
    open var onEndDisplay: ((_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void)?
    open var onHighlight: ((_ indexPath: IndexPath) -> Void)?
    open var onUnighlight: ((_ indexPath: IndexPath) -> Void)?
    open var shouldHighlight: Bool?
    /// Width of cell = collectionView.width - horizontal section insets
    open var adjustsWidth: Bool = false
    /// Height of cell = collectionView.height - vertical section insets
    open var adjustsHeight: Bool = false
    
    open var item: CellType.T
    open var reuseIdentifier: String { return CellType.reuseIdentifier }
    
    public let identifier: String = UUID().uuidString
    
    public func estimatedSize(collectionViewSize: CGSize) -> CGSize {
        return CellType.estimatedSize(item: self.item, collectionViewSize: collectionViewSize)
    }
    
    public var cellType: AnyClass {
        return CellType.self
    }
    
    public init(item: CellType.T) {
        self.item = item
    }
    
    public func configure(_ cell: UICollectionReusableView) {
        (cell as? CellType)?.configure(item: item)
    }
    
    public func reload(item: CellType.T) {
        self.item = item
        postReloadNotofication(subject: .item, object: self)
    }
    
    @discardableResult
    public func onSelect(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onSelect = block
        return self
    }
    
    @discardableResult
    public func onDeselect(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onDeselect = block
        return self
    }

    @discardableResult
    public func onDisplay(_ block:@escaping (_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void) -> Self {
        self.onDisplay = block
        return self
    }
    
    @discardableResult
    public func onEndDisplay(_ block:@escaping (_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void) -> Self {
        self.onEndDisplay = block
        return self
    }
    
    @discardableResult
    public func onHighlight(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onHighlight = block
        return self
    }
    
    @discardableResult
    public func onUnighlight(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onUnighlight = block
        return self
    }
}
