//
//  ImageCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 1/29/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class ImageCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}

extension ImageCell: ConfigurableCollectionItem {
    func configure(item: UIImage) {
        imageView.image = item
    }
    
    static func estimatedSize(item: UIImage?, boundingSize: CGSize) -> CGSize {
        let width: CGFloat = ((boundingSize.width - 6) / 2).rounded(.down)
        return CGSize(width: width, height: width * 0.8)
    }
}
