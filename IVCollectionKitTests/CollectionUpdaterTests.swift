//
//  CollectionUpdaterTests.swift
//  IVCollectionKitTests
//
//  Created by Igor Vedeneev on 4/25/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import XCTest
@testable import IVCollectionKit

class CollectionUpdaterTests: IVTestCase {
    private lazy var updater = CollectionUpdater(collectionView)
    var section1 = CollectionSection()
    var section2 = CollectionSection()
    
    func test_emptyDirectorReturnsReload() {
        director += section1
        
        let u = _updates()
        let isReload: Bool
        switch u {
        case .reload:
            isReload = true
        default:
            isReload = false
        }
       
        XCTAssert(isReload, "unexpected update type. expected reload, got update")
    }
    
    func test_OnlyItemsUpdate() {
        director += section1
        
        director.reload()
        collectionView.layoutIfNeeded()
        
        section1 += CollectionItem<StringCell>(item: "1")
        
        let updates = _updates()
        
        if case Update.update(let sections, let items) = updates {
            XCTAssert(sections.isEmpty
                && items.inserts.count == 1
                && items.deletes.isEmpty
                && items.replaces.isEmpty
                && items.moves.isEmpty, "incorrect updates")
        } else {
            XCTAssert(false, "incorrect update type. expected update but got reload")
        }
    }
    
    func test_sectionAndItemsUpdate() {
        director += section1
        director.reload()
        collectionView.layoutIfNeeded()
        
        director.remove(section: section1)
        director += section2
        section2 += CollectionItem<StringCell>(item: "1")
        section2 += CollectionItem<StringCell>(item: "2")
        
        let u = _updates()
        if case Update.update(let sections, let items) = u {
            let sectionDeletesCount = sections.compactMap { $0.delete }.count
            let sectionInsertsCount = sections.compactMap { $0.insert }.count
            
            XCTAssert(sections.count == 2, "incorrect sections update count")
            XCTAssert(sectionDeletesCount == 1, "incorrect sections DELETES count")
            XCTAssert(sectionInsertsCount == 1, "incorrect sections INSERTS count")
            
            XCTAssert(items.inserts.count == 0 // ignore inserts in new section
                && items.deletes.isEmpty
                && items.replaces.isEmpty
                && items.moves.isEmpty, "incorrect updates")
        } else {
            XCTAssert(false, "incorrect update type. expected update but got reload")
        }
    }
    
    /// delete item from section 0 and insert section at 0
    func test_deleteItemAndInsertSection() {
        director += section2
        section2 += CollectionItem<StringCell>(item: "1")
        
        reload()
        
        director += section1
        section2.removeAll()
        
        let u = _updates()
        
        if case Update.update(let sections, let items) = u {
            let sectionInsertsCount = sections.compactMap { $0.insert }.count
            
            XCTAssert(sectionInsertsCount == 1, "incorrect sections INSERTS count")
            XCTAssert(items.deletes.count == 1, "expected one item DELETE, got \(items.deletes.count)")
            let itemUpdate = items.deletes.first!
            XCTAssert(itemUpdate.section == 0, "incorrect delete indexpath")
        } else {
            XCTAssert(false, "incorrect update type. expected update but got reload")
        }
    }
    
    func test_moveItemAndPreviousSection() {
        
    }
    
    private func _updates() -> Update {
        return updater.calculateUpdates(oldSectionIds: director.sectionIds,
                                        currentSections: director.sections,
                                        itemMap: director.lastCommitedSectionAndItemsIdentifiers,
                                        forceReloadDataForLargeAmountOfChanges: false)
    }
}
