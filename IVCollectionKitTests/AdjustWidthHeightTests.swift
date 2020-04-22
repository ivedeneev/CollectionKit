//
//  AdjustWidthHeightTests.swift
//  IVCollectionKitTests
//
//  Created by Igor Vedeneev on 2/15/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import XCTest
@testable import IVCollectionKit

final class AdjustWidthHeightTests: IVTestCase {
    
    func testAdjustWidth_noInsets() {
        let section1 = CollectionSection()
        section1 += CollectionItem<TestCell>(item: ()).adjustsWidth(true)
        director += section1
        director.reload()
        collectionView.layoutIfNeeded()
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) else { XCTFail("missing cell"); return }
        let realWidth = cell.bounds.width
        let expectedWidth = UIScreen.main.bounds.width
        XCTAssert(realWidth == expectedWidth, "real width: \(realWidth), expected width: \(expectedWidth)")
    }
    
    func testAdjustWidth_sectionInsets() {
        let section1 = CollectionSection()
        let inset: CGFloat = 15
        section1.insetForSection = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        section1 += CollectionItem<TestCell>(item: ()).adjustsWidth(true)
        director += section1
        director.reload()
        collectionView.layoutIfNeeded()
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) else { XCTFail("missing cell"); return }
        let realWidth = cell.bounds.width
        let expectedWidth = UIScreen.main.bounds.width - 2 * inset
        XCTAssert(realWidth == expectedWidth, "real width: \(realWidth), expected width: \(expectedWidth)")
    }
    
    func testAdjustWidth_contentInsetsAndSectionInsets() {
        let section1 = CollectionSection()
        let inset: CGFloat = 15
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        section1.insetForSection = UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset)
        section1 += CollectionItem<TestCell>(item: ()).adjustsWidth(true)
        director += section1
        director.reload()
        collectionView.layoutIfNeeded()
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) else { XCTFail("missing cell"); return }
        let realWidth = cell.bounds.width
        let expectedWidth = UIScreen.main.bounds.width - 4 * inset
        XCTAssert(realWidth == expectedWidth, "real width: \(realWidth), expected width: \(expectedWidth)")
    }
}
