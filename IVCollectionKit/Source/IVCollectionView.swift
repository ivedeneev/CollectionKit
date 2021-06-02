//
//  IVCollectionView.swift
//  IVCollectionKit
//
//  Created by Igor Vedeneev on 10.10.2020.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit

/// `UICollectionView` subclass designed for more safe batch updates
/// I know, this is bad :(, but sometimes espesially during multiple updates something goes wrong and it crashes
open class IVCollectionView: UICollectionView {
    open override func deleteItems(at indexPaths: [IndexPath]) {
        let safeIndexPaths = indexPaths.filter { collectionViewLayout.layoutAttributesForItem(at: $0) != nil }
        super.deleteItems(at: safeIndexPaths)
    }
    
    open override func insertItems(at indexPaths: [IndexPath]) {
        let safeIndexPaths = indexPaths.filter { collectionViewLayout.layoutAttributesForItem(at: $0) != nil }
        super.insertItems(at: safeIndexPaths)
    }
}
