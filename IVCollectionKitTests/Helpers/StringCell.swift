//
//  StringCell.swift
//  IVCollectionKitTests
//
//  Created by Igor Vedeneev on 4/25/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import XCTest
@testable import IVCollectionKit

class StringCell: UICollectionViewCell, ConfigurableCollectionItem {
    let titleLabel = UILabel()
    
    static func estimatedSize(item: String, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
    
    func configure(item: String) {
        titleLabel.text = item
    }
}
