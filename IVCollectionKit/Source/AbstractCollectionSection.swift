//
//  AbstractCollectionSection.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 09.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

public protocol AbstractCollectionSection {
    
    var identifier: String { get }
    var isEmpty: Bool { get }
    
    var headerItem: AbstractCollectionHeaderFooterItem? { get set }
    var footerItem: AbstractCollectionHeaderFooterItem? { get set }
    
    var insetForSection: UIEdgeInsets { get set }
    var minimumInterItemSpacing: CGFloat { get set }
    var lineSpacing: CGFloat { get set }
    
    //datasource methods
    func numberOfItems() -> Int
    func item(for index: Int) -> AbstractCollectionItem
    
    //delegate methods
    func willDisplayItem(at indexPath: IndexPath, cell: UICollectionViewCell)
    func didEndDisplayingItem(at indexPath: IndexPath, cell: UICollectionViewCell)
    func didSelectItem(at indexPath: IndexPath)
    func didDeselectItem(at indexPath: IndexPath)
    func shouldHighlightItem(at indexPath: IndexPath) -> Bool
    func didHighlightItem(at indexPath: IndexPath)
    func didUnhighlightItem(at indexPath: IndexPath)
    func sizeForItem(at indexPath: IndexPath, boundingSize: CGSize) -> CGSize
    
    func itemAdjustsWidth(at index: Int) -> Bool
    func itemAdjustsHeight(at index: Int) -> Bool
    
    func append(item: AbstractCollectionItem)
    func append(items: [AbstractCollectionItem])
    func removeAll()
    
    func currentItemIds() -> [String]
}

/// Default implementation for very rare used methods
public extension AbstractCollectionSection {
    var isEmpty: Bool { return numberOfItems() == 0 }
    
    func willDisplayItem(at indexPath: IndexPath, cell: UICollectionViewCell) {}
    func didEndDisplayingItem(at indexPath: IndexPath, cell: UICollectionViewCell) {}
    func didDeselectItem(at indexPath: IndexPath) {}
    func shouldHighlightItem(at indexPath: IndexPath) -> Bool { return true }
    func didHighlightItem(at indexPath: IndexPath) {}
    func didUnhighlightItem(at indexPath: IndexPath) {}
    func itemAdjustsWidth(at index: Int) -> Bool { return false }
    func itemAdjustsHeight(at index: Int) -> Bool { return false }
}
