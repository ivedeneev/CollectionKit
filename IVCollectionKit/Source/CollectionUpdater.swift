//
//  CollectionUpdater.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 22.11.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

final class CollectionUpdater {
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
}
