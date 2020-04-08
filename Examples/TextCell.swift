//
//  TextCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 1/29/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class TextCell: UICollectionViewCell {
    private let label = UILabel()
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .separator : .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 16, y: 0, width: bounds.width - 16 * 2, height: bounds.height)
    }
}

extension TextCell: ConfigurableCollectionItem {
    func configure(item: String) {
        label.text = item
    }
    
    static func estimatedSize(item: String?, boundingSize: CGSize) -> CGSize {
        return CGSize(width: boundingSize.width - 40, height: 44)
    }
}
