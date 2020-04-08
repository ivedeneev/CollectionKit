//
//  IVCollectionKitTests.swift
//  IVCollectionKitTests
//
//  Created by Igor Vedeneev on 1/29/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import XCTest
@testable import IVCollectionKit

class IVTestCase: XCTestCase {
    let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var director = CollectionDirector(colletionView: collectionView)
    
    override func tearDown() {
        director.removeAll()
        director.reload()
        collectionView.layoutIfNeeded()
        super.tearDown()
    }
    
    override func setUp() {
        super.setUp()
    }
}

class IVCollectionKitTests: IVTestCase {
    
//    let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
//    lazy var director = CollectionDirector(colletionView: collectionView)
    
    override func setUp() {
        super.setUp()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testAppendItem() {
////        self.director.
//        
//        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
//        let director = CollectionDirector(colletionView: collectionView)
//        
//        let section1 = CollectionSection()
//        director += section1
//        director.reload()
//        director.performUpdates(updates: {
//            section1 += CollectionItem<TestCell>(item: ())
//        }) {
//            XCTAssert(collectionView.numberOfItems(inSection: 0) == 1)
//        }
//    }
    
    func testInsertDeleteItems() {
        
    }
}

final class TestCell : UICollectionViewCell, ConfigurableCollectionItem {
    func configure(item: Void) {
        
    }
    
    static func estimatedSize(item: ()?, boundingSize collectionViewSize: CGSize) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}


extension String {
    public var diffId: String {
        return self
    }
    
    public static func compareContent(_ a: String, _ b: String) -> Bool {
        return a == b
    }
}
