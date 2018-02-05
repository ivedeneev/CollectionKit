//
//  CollectionUpdater.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 22.11.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation

final class CollectionUpdater {
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func apply(change: AbstractCollectionUpdate) {
        switch change {
        case let update as ItemUpdate:
            handleItemUpdate(update: update)
        case let update as SectionUpdate:
            handleSectionUpdate(update: update)
        default: break
        }
    }
    
    func apply(changes: [AbstractCollectionUpdate]) {
        changes.forEach { [unowned self] (change) in
            self.apply(change: change)
        }
    }
    
    func handleItemUpdate(update: ItemUpdate) {
        switch update.type {
        case .reload:
            collectionView.reloadItems(at: update.indexPaths)
            break
        case .insert:
            collectionView.insertItems(at: update.indexPaths)
            break
        case .delete:
            collectionView.deleteItems(at: update.indexPaths)
            break
        }
    }
    
    func handleSectionUpdate(update: SectionUpdate) {
        let indexSet = IndexSet(update.indicies)
        switch update.type {
        case .reload:
            collectionView.reloadSections(indexSet)
            break
        case .insert:
            collectionView.insertSections(indexSet)
            break
        case .delete:
            collectionView.deleteSections(indexSet)
            break
        }
    }
}
