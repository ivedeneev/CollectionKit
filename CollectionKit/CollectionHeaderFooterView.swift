//
//  CollectionHeaderFooterView.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 25.10.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation

//open class CollectionHeaderFooterView<CellType: ConfigurableCollectionItem>: AbstractCollectionItem where CellType: UICollectionReusableView {
//    open var estimatedSize: CGSize { return CellType.estimatedSize(item: self.item) }
//    open var item: CellType.T
//    open var reuseIdentifier: String { return CellType.reuseIdentifier }
//    open var onSelect: ((_ indexPath: IndexPath) -> Void)?
//    open var onDeselect: ((_ indexPath: IndexPath) -> Void)?
//    open var onDisplay: ((_ indexPath: IndexPath) -> Void)?
//    open var onEndDisplay: ((_ indexPath: IndexPath) -> Void)?
//    open var onHighlight: ((_ indexPath: IndexPath) -> Void)?
//    open var onUnighlight: ((_ indexPath: IndexPath) -> Void)?
//    open var shouldHighlight: Bool?
//    
//    public init(item: CellType.T) {
//        self.item = item
//    }
//    
//    public func configure(_ cell: UICollectionReusableView) {
//        (cell as? CellType)?.configure(item: item)
//    }
//}

