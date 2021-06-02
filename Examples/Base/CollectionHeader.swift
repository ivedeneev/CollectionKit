//
//  CollectionHeader.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/17/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class CollectionHeader: UICollectionReusableView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionHeader: ConfigurableCollectionItem {
    static func estimatedSize(item: String, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        return CGSize(width: boundingSize.width, height: 48)
    }
    
    func configure(item: String) {
        label.text = item.uppercased()
    }
}

final class CollectionFooter: UICollectionReusableView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionFooter: ConfigurableCollectionItem {
    static func estimatedSize(item: String, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        let labelSize = CGSize(width: boundingSize.width - 32, height: .greatestFiniteMagnitude)
        let textHeight = (item as NSString)
            .boundingRect(
                with: labelSize,
                options: [.usesFontLeading, .usesLineFragmentOrigin],
                attributes: [.font : UIFont.systemFont(ofSize: 12, weight: .light)],
                context: nil
            ).height.rounded(.up)
        return CGSize(width: boundingSize.width, height: textHeight + 8)
    }
    
    func configure(item: String) {
        label.text = item.capitalized
    }
}

