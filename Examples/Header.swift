//
//  Header.swift
//  Examples
//
//  Created by Igor Vedeneev on 03.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

final class Header: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        titleLabel.frame = CGRect(x: 20, y: 20, width: 100, height: 13)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Header : ConfigurableCollectionItem {
    func configure(item: String) {
        titleLabel.text = item.uppercased()
    }
    
    static func estimatedSize(item: String?, collectionViewSize: CGSize) -> CGSize {
        return CGSize(width: collectionViewSize.width, height: 48)
    }
}
