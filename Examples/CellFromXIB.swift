//
//  CellFromXIB.swift
//  Examples
//
//  Created by Igor Vedeneev on 26.11.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

final class CellFromXIB : UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

extension CellFromXIB : ConfigurableCollectionItem {
    static func estimatedSize(item: String?, collectionViewSize: CGSize) -> CGSize {
        return CGSize(width: collectionViewSize.width - 40, height: 60)
    }
    
    func configure(item: String) {
        label.text = item
    }
}
