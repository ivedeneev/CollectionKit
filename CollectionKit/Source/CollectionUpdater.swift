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
        changes.forEach { [weak self] (change) in
            guard let `self` = self else { return }
            self.apply(change: change)
        }
    }
    
    func handleItemUpdate(update: ItemUpdate) {
        let indexPaths = update.indexPaths.filter { [weak self] ip -> Bool in
            guard let `self` = self else { return false }
             return self.collectionView.isValidIndexPath(ip) || update.type == UpdateActionType.insert
        }
        switch update.type {
        case .reload:
            collectionView.reloadItems(at: indexPaths)
            break
        case .insert:
            collectionView.insertItems(at: indexPaths)
            break
        case .delete:
            collectionView.deleteItems(at: indexPaths)
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
