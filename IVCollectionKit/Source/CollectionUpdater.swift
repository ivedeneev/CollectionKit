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
    
//    func performUpdates(itemChanges: [ChangeWithIndexPath],
//                        sectionChanges: [Change<String>],
//                        forceReloadDataForLargeAmountOfChanges: Bool,
//                        completion: (() -> Void)?)
//    {
//        if sectionChanges.count > 50 && forceReloadDataForLargeAmountOfChanges {
//            collectionView?.reloadData()
//            completion?()
//            return
//        }
//        
//        collectionView?.performBatchUpdates({ [weak self] in
//            guard let `self` = self, let collectionView = self.collectionView else { return }
//
//            itemChanges.forEach { (changesWithIndexPath) in
//                
//                changesWithIndexPath.deletes.executeIfPresent { deletes in
//                    let indexPaths: [IndexPath]
//                    
//                    if !sectionChanges.isEmpty {
//                        let oldSections = deletes.map { newSectionIds[$0.section] }.compactMap { oldSectionIds.firstIndex(of: $0) }
//                        indexPaths = zip(deletes, oldSections).map { IndexPath(item: $0.item, section: $1) }
//                    } else {
//                        indexPaths = deletes
//                    }
//                    
//                    self.collectionView.deleteItems(at: indexPaths)
//                }
//
//                changesWithIndexPath.inserts.executeIfPresent {
//                  self.collectionView.insertItems(at: $0)
//                }
//
//                changesWithIndexPath.moves.executeIfPresent {
//                  $0.forEach { move in
//                    let from: IndexPath
//                    let to: IndexPath = move.to
//                    if !sectionChanges.isEmpty {
//                        let sectionId = newSectionIds[move.to.section]
//                        guard let oldSectionIdx = oldSectionIds.firstIndex(of: sectionId) else {
//                            fatalError("Attemt to move from section which doesnt belong to director before update.")
//                        }
//                        from = IndexPath(item: move.from.item, section: oldSectionIdx)
//                    } else {
//                        from = move.from
//                    }
//
//                    self.collectionView.moveItem(at: from, to: to)
//                  }
//                }
//            }
//            
//            let sectionDeletes = sectionChanges.compactMap { $0.delete?.index }
//            sectionDeletes.executeIfPresent { deletes in
//                self.collectionView.deleteSections(IndexSet(deletes))
//            }
//
//            let sectionInserts = sectionChanges.compactMap { $0.insert?.index }
//            sectionInserts.executeIfPresent { inserts in
//                self.collectionView.insertSections(IndexSet(inserts))
//            }
//
//            sectionChanges.compactMap { $0.move }.executeIfPresent { moves in
//                moves.forEach { self.collectionView.moveSection($0.fromIndex, toSection: $0.toIndex) }
//            }
//        }) { _ in
//            completion?()
//        }
//
//        itemChanges.flatMap { $0.replaces }.executeIfPresent { [weak self] in
//            self?.collectionView.reloadItems(at: $0)
//        }
//        
//        sectionChanges.compactMap { $0.replace?.index }.executeIfPresent { [weak self] in
//            self?.collectionView.reloadSections(IndexSet($0))
//        }
//    }
}
