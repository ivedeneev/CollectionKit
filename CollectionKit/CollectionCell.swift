//
//  CollectionCell.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell, ConfigurableCollectionItem {
    typealias T = String
    
    fileprivate let imageView = UIImageView()
    fileprivate let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        imageView.frame = CGRect(x: 25, y: 25, width: 100, height: 120)
        addSubview(imageView)
        imageView.backgroundColor = .red
        textLabel.frame = CGRect(x: 25, y: 170, width: 100, height: 20)
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func estimatedSize(item: String? = nil) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func configure(item: String) {
        textLabel.text = item
    }
}
