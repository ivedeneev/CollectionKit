//
//  CollectionItem.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

/// Class represents cell model. Stores cell viewModel.
/// Responsible for cell size calculation and all events handling(e.g `onSelect`, `onDisplay`)
open class CollectionItem<CellType: ConfigurableCollectionItem>: AbstractCollectionItem where CellType: UICollectionViewCell {
    /// called when `collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)` called
    open var onSelect: ((_ indexPath: IndexPath) -> Void)?
    open var onDeselect: ((_ indexPath: IndexPath) -> Void)?
    open var onDisplay: ((_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void)?
    open var onEndDisplay: ((_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void)?
    open var onHighlight: ((_ indexPath: IndexPath) -> Void)?
    open var onUnighlight: ((_ indexPath: IndexPath) -> Void)?
    open var shouldSelect: Bool = true
    open var shouldDeselect: Bool = true
    open var shouldHighlight: Bool = true
    /// Width of cell = collectionView.width - horizontal section insets - horizontal collectionView insets.
    /// Width from `estimatedSize(boundingSize:)` will be ignored
    open var adjustsWidth: Bool = false
    /// Height of cell = collectionView.height - vertical section insets - vertical collectionView insets
    /// Height from `estimatedSize(boundingSize:)` will be ignored
    open var adjustsHeight: Bool = false
    /// ViewModel for
    open private(set) var item: CellType.T
    open var reuseIdentifier: String { return CellType.reuseIdentifier }
    /// identifier used for diff calculating
    public var identifier: String {
        let hashableId: AnyHashable = (item as? AnyHashable) ?? UUID().uuidString as AnyHashable
        let hashValue = hashableId.hashValue
        return reuseIdentifier + "_" + String(hashValue)
    }
    
    public func estimatedSize(boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        return CellType.estimatedSize(item: item, boundingSize: boundingSize, in: section)
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
    /// Width of cell = collectionView.width - horizontal section insets - horizontal collectionView insets.
    /// Width from `estimatedSize(boundingSize:)` will be ignored
    @discardableResult
    public func adjustsWidth(_ adjusts: Bool) -> Self {
        self.adjustsWidth = adjusts
        return self
    }
    /// Height of cell = collectionView.height - vertical section insets - vertical collectionView insets
    /// Height from `estimatedSize(boundingSize:)` will be ignored
    @discardableResult
    public func adjustsHeight(_ adjusts: Bool) -> Self {
        self.adjustsHeight = adjusts
        return self
    }
    
    @discardableResult
    public func shouldHighlight(_ value: Bool) -> Self {
        self.shouldHighlight = value
        return self
    }
    
    @discardableResult
    public func shouldSelect(_ value: Bool) -> Self {
        self.shouldSelect = value
        return self
    }
    
    @discardableResult
    public func shouldDeselect(_ value: Bool) -> Self {
        self.shouldDeselect = value
        return self
    }
}

public protocol SelectableCellViewModel {
    var onSelect: ((IndexPath) -> ())? { get set }
}

public extension CollectionItem where CellType.T: SelectableCellViewModel {
    /// If cell viewModel conforms `SelectableCellViewModel`, u can replace `onSelect` implementation of `CollectionItem` with `onSelectFromViewModel()` in cell viewModel
    ///
    /// ViewModel implemendation and creation:
    /// ```
    /// class TestViewModel: SelectableCellViewModel {
    ///     var onSelect: ((IndexPath) -> ())?
    /// }
    ///
    /// let viewModel = TestViewModel()
    /// viewModel.onSelect = { indexPath in
    ///     print(indexPath)
    /// }
    /// ```
    ///
    /// Usage:
    /// `let testItem = CollectionItem<TestCell>(item: viewModel).onSelectFromViewModel()`
    /// - note: uses `unowned self` reference
    @discardableResult
    func onSelectFromViewModel() -> Self {
        return onSelect { [unowned self] (indexPath) in
            self.item.onSelect?(indexPath)
        }
    }
}
