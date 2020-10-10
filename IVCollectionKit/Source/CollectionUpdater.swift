//
//  CollectionUpdater.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 22.11.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

/// Update model for collectionView
enum Update {
    /// `reloadData` should be called
    case reload
    /// Section and itenms update for `performBatchUpdate` method
    case update(sections: [Change<String>], items: ChangeWithIndexPath)
}

/// Responsible for update calculation
final class CollectionUpdater {
    
    init(_ cv: UICollectionView?) {
        self.collectionView = cv
    }
    
    weak var collectionView: UICollectionView?

    func calculateUpdates(oldSectionIds: [String],
                          currentSections: [AbstractCollectionSection],
                          itemMap: [String: [String]],
                          forceReloadDataForLargeAmountOfChanges: Bool) -> Update
    {
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
        
        let inserts = itemChanges.flatMap { $0.inserts }
        let reloads = itemChanges.flatMap { $0.replaces }
        if sectionChanges.isEmpty {
            return .update(
                sections: sectionChanges,
                items: ChangeWithIndexPath(
                    inserts: inserts,
                    deletes: itemChanges.flatMap { $0.deletes },
                    replaces: reloads,
                    moves: itemChanges.flatMap { $0.moves }
                )
            )
        }
        
        var deletes = Array<IndexPath>()
        deletes.reserveCapacity(itemChanges.flatMap { $0.deletes }.count)
        
        var moves = Array<(from: IndexPath, to: IndexPath)>()
        moves.reserveCapacity(itemChanges.flatMap { $0.moves }.count)
        
        
        var sectionMap = Dictionary<Int, Int>() // map between old and new section indicies
        for i in 0..<newSectionIds.count {
            sectionMap[i] = oldSectionIds.firstIndex(of: newSectionIds[i])
        }
        
        // we MUST use section index before updates in deletes and moves(from) operations
        itemChanges.forEach { (changesWithIndexPath) in
            changesWithIndexPath.deletes.executeIfPresent { _deletes in
                
                let fixedDeletes = _deletes.map { indexPath -> IndexPath in
                    let fixedSection = sectionMap[indexPath.section] ?? indexPath.section
                    return IndexPath(item: indexPath.item, section: fixedSection)
                }
                
                deletes.append(contentsOf: fixedDeletes)
            }
            
            changesWithIndexPath.moves.executeIfPresent { _moves in
                let fixedMoves = _moves.map { (arg) -> (IndexPath, IndexPath) in
                    let (from, to) = arg
                    let fixedFromSection = sectionMap[from.section] ?? from.section
                    let fixedFromIndexPath = IndexPath(item: from.item, section: fixedFromSection)
                    return (fixedFromIndexPath, to)
                }
                
                moves.append(contentsOf: fixedMoves)
            }
        }
        
        return .update(sections: sectionChanges,
                       items: ChangeWithIndexPath(
                            inserts: itemChanges.flatMap { $0.inserts },
                            deletes: deletes,
                            replaces: itemChanges.flatMap { $0.replaces },
                            moves: moves
                       )
        )
    }
}
