//
//  CollectionKitTests.swift
//  CollectionKitTests
//
//  Created by Igor Vedeneev on 10/12/18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import XCTest
import CollectionKit

class CollectionKitTests: XCTestCase {
    
    let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var director = CollectionDirector(colletionView: collectionView)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFillDirector() {
        director.clear()
        director.reload()
        
        let section1 = CollectionSection()
        section1 += CollectionItem<TestCell>(item: ())
        section1 += CollectionItem<TestCell>(item: ())
        director += section1
        
        let section2 = CollectionSection()
        section2 += CollectionItem<TestCell>(item: ())
        section2 += CollectionItem<TestCell>(item: ())
        director += section2
        
        director.reload()
        
        let numberOfSections = collectionView.numberOfSections == 2
        let numberOfItemsInSection0 = collectionView.numberOfItems(inSection: 0) == 2
        let numberOfItemsInSection1 = collectionView.numberOfItems(inSection: 1) == 2
        print(numberOfSections, numberOfItemsInSection0, numberOfItemsInSection1)
        
        XCTAssert(numberOfSections && numberOfItemsInSection0 && numberOfItemsInSection1)
    }
    
    func testAppendItem() {
//        self.director.
        
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        let director = CollectionDirector(colletionView: collectionView)
        
        let section1 = CollectionSection()
        director += section1
        director.reload()
        director.performUpdates(updates: {
            section1 += CollectionItem<TestCell>(item: ())
        }) {
            XCTAssert(collectionView.numberOfItems(inSection: 0) == 1)
        }
    }
    
    func testInsertDeleteItems() {
        
    }
}

final class TestCell : UICollectionViewCell, ConfigurableCollectionItem {
    func configure(item: Void) {
        
    }
    
    static func estimatedSize(item: ()?, collectionViewSize: CGSize) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
