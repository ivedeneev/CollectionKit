//
//  CollectionItem.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

class CollectionItem<CellType: ConfigurableCollectionItem>: AbstractCollectionItem where CellType: UICollectionReusableView {
    //todo: consider item as parameter
    var onSelect: ((_ indexPath: IndexPath) -> Void)?
    var onDeselect: ((_ indexPath: IndexPath) -> Void)?
    var onDisplay: ((_ indexPath: IndexPath) -> Void)?
    var onEndDisplay: ((_ indexPath: IndexPath) -> Void)?
    
    var estimatedSize: CGSize { return CellType.estimatedSize(item: self.item) }
    var item: CellType.T
    var reuseIdentifier: String { return CellType.reuseIdentifier }
    
    init(item: CellType.T) {
        self.item = item
    }
    
    func configure(_ cell: UICollectionReusableView) {
        (cell as? CellType)?.configure(item: item)
    }
    
    func reload(item: CellType.T) {
        self.item = item
    }
    
    func onSelect(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onSelect = block
        return self
    }
    
    func onDeselect(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onDeselect = block
        return self
    }

    func onDisplay(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onDisplay = block
        return self
    }
    
    func onEndDisplay(_ block:@escaping (_ indexPath: IndexPath) -> Void) -> Self {
        self.onEndDisplay = block
        return self
    }
}
