//
//  CollectionUpdater.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 22.11.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

enum Update {
    case reload
    case update(sections: [Change<String>], items: Array<ChangeWithIndexPath>)
}

final class CollectionUpdater {
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func calculateUpdates(oldSectionIds: [String],
                          currentSections: [AbstractCollectionSection],
                          itemMap: [String: [String]],
                          forceReloadDataForLargeAmountOfChanges: Bool) -> Update
    {
        // if there is no sections in collectionView, it crashes :(
        if oldSectionIds.isEmpty {
            return .reload
        }
        
        let newSectionIds = currentSections.map { $0.identifier }
        let sectionChanges = diff(old: oldSectionIds, new: newSectionIds)
        let converter = IndexPathConverter()
               
        if sectionChanges.count > 50 && forceReloadDataForLargeAmountOfChanges {
            return .reload
        }
        
        var itemChanges = Array<ChangeWithIndexPath>()
        currentSections.enumerated().forEach { (idx, section) in
            let oldItemIds = itemMap[section.identifier] ?? section.currentItemIds()
            let diff_ = diff(old: oldItemIds, new: section.currentItemIds())
            guard !diff_.isEmpty else { return }
            itemChanges.append(converter.convert(changes: diff_, section: idx))
        }
        
        var deletes = Array<IndexPath>()
        deletes.reserveCapacity(itemChanges.flatMap { $0.deletes }.count)
        let inserts = itemChanges.flatMap { $0.inserts }
        var moves = itemChanges.flatMap { $0.moves }
        let reloads = itemChanges.flatMap { $0.replaces }
        
        itemChanges.forEach { (changesWithIndexPath) in
            changesWithIndexPath.deletes.executeIfPresent { _deletes in
                let indexPaths: [IndexPath]
                
                if !sectionChanges.isEmpty {
                    let oldSections = _deletes
                        .compactMap { oldSectionIds.firstIndex(of: newSectionIds[$0.section] ) }
                    
                    indexPaths = zip(_deletes, oldSections).map { IndexPath(item: $0.item, section: $1) }
                } else {
                    indexPaths = _deletes
                }
                
                deletes = indexPaths
            }
            
            changesWithIndexPath.moves.executeIfPresent {
              $0.forEach { move in
                let from: IndexPath
                let to: IndexPath = move.to
                if !sectionChanges.isEmpty {
                    let sectionId = newSectionIds[move.to.section]
                    guard let oldSectionIdx = oldSectionIds.firstIndex(of: sectionId) else {
                        fatalError("Attemt to move from section which doesnt belong to director before update.")
                    }
                    from = IndexPath(item: move.from.item, section: oldSectionIdx)
                } else {
                    from = move.from
                }

                moves.append((from, to))
              }
            }
        }
        
        return .update(sections: sectionChanges, items: [])
    }
}
