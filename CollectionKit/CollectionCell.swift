//
//  CollectionCell.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit


class CollectionCell: UICollectionViewCell, ConfigurableCollectionItem {
    typealias T = String
    
    fileprivate let imageView = UIImageView()
    fileprivate let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        imageView.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        addSubview(imageView)
        imageView.backgroundColor = .red
        textLabel.frame = CGRect(x: 60, y: 0, width: 200, height: 50)
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func estimatedSize(item: String? = nil) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
    
    func configure(item: String) {
        textLabel.text = item
    }
}
