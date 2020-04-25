//
//  AnimatedUpdatesTests.swift
//  IVCollectionKitTests
//
//  Created by Igor Vedeneev on 2/24/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import XCTest

class AnimatedUpdatesTests: IVTestCase {
    
    var section1 = CollectionSection()
    var section2 = CollectionSection()

    func test_simpleUpdates() {
        director += section1
        section1 += ["1", "2", "3"].map(CollectionItem<StringCell>.init)
        
        director.reload()
        collectionView.layoutIfNeeded()
        
        director += section2
        section2 += ["4", "5", "6", "7"].map(CollectionItem<StringCell>.init)
        
        let e = expectation(description: "perform updates")
        director.performUpdates(forceReloadDataForLargeAmountOfChanges: false) {
            e.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (e) in
            XCTAssert(self.collectionView.numberOfSections == 2)
            XCTAssert(self.collectionView.numberOfItems(inSection: 0) == 3)
            XCTAssert(self.collectionView.numberOfItems(inSection: 1) == 4)
        }
    }
    
    func test_section_and_items_update() {
        director += section1
        section1 += ["1", "2", "3"].map(CollectionItem<StringCell>.init)
        
        director.reload()
        collectionView.layoutIfNeeded()
        
        director.insert(section: section2, at: 0)
        let insertSectionsStrings = ["4", "5", "6", "7"]
        section2 += insertSectionsStrings.map(CollectionItem<StringCell>.init)
        
        section1.items.remove(at: 0)
        section1.items.insert(CollectionItem<StringCell>(item: "test"), at: 0)
        
        let e = expectation(description: "perform updates")
        director.performUpdates(forceReloadDataForLargeAmountOfChanges: false) {
            e.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { (e) in
            XCTAssert(self.collectionView.numberOfSections == 2)
            XCTAssert(self.collectionView.numberOfItems(inSection: 0) == 4)
            XCTAssert(self.collectionView.numberOfItems(inSection: 1) == 3)
            
            let indexPaths = Array(0..<4).map { IndexPath(item: $0, section: 0) }
            let cells = indexPaths.compactMap { self.collectionView.cellForItem(at: $0) as? StringCell }
            XCTAssert(cells.count == 4)
            let texts = zip(insertSectionsStrings, cells.compactMap { $0.titleLabel.text })
            let textsAreEqual = texts.reduce(true, { $0 && $1.0 == $1.1 })
            XCTAssert(textsAreEqual)
        }
    }
    
    func test_onlyItemsUpdate() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

private class StringCell: UICollectionViewCell, ConfigurableCollectionItem {
    let titleLabel = UILabel()
    
    static func estimatedSize(item: String, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
    
    func configure(item: String) {
        titleLabel.text = item
    }
}
