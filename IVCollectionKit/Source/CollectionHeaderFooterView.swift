//
//  CollectionHeaderFooterView.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 25.10.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

open class CollectionHeaderFooterView<ViewType: ConfigurableCollectionItem>: AbstractCollectionHeaderFooterItem where ViewType: UICollectionReusableView {
    public let kind: String
    public var viewType: AnyClass { return ViewType.self }
    public var indexPath: String?
    open var item: ViewType.T
    open var onDisplay: (() -> Void)?
    open var onEndDisplay: (() -> Void)?
    open var reuseIdentifier: String { return ViewType.reuseIdentifier }
    public let identifier: String = UUID().uuidString
    
    public init(item: ViewType.T, kind: String) {
        self.item = item
        self.kind = kind
    }
    
    public func configure(_ view: UICollectionReusableView) {
        (view as? ViewType)?.configure(item: item)
    }
    
    public func estimatedSize(boundingSize: CGSize) -> CGSize {
        return ViewType.estimatedSize(item: self.item, boundingSize: boundingSize)
    }
    
    @discardableResult
    public func onDisplay(_ block:@escaping () -> Void) -> Self {
        self.onDisplay = block
        return self
    }
    
    @discardableResult
    public func onEndDisplay(_ block:@escaping () -> Void) -> Self {
        self.onEndDisplay = block
        return self
    }
}
