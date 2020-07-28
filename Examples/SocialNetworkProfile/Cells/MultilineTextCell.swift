//
//  MultilineTextCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 7/28/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class MultilineTextCell: UICollectionViewCell {
    
    private let textLabel = UILabel()
    
    static let font = UIFont.systemFont(ofSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        layer.cornerRadius = 8
        setupTextLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextLabel() {
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.backgroundColor = .systemBackground
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        textLabel.numberOfLines = 0
        textLabel.font = Self.font
    }
}

extension MultilineTextCell: ConfigurableCollectionItem {
    static func estimatedSize(item: MultilineTextViewModel, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        
        let font = Self.font
        let maxHeight: CGFloat = item.isExpanded ? .greatestFiniteMagnitude : font.lineHeight.rounded(.up) * 3
        let w = boundingSize.width - 16 - section.insetForSection.left - section.insetForSection.right
        let height: CGFloat = (item.text as NSString).boundingRect(
            with: CGSize(width: w, height: maxHeight),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font: font],
            context: nil).height
        
        return CGSize(width: boundingSize.width, height: height.rounded(.up) + 16)
    }
    
    func configure(item: MultilineTextViewModel) {
        textLabel.text = item.text
    }
}

final class MultilineTextViewModel {
    let text: String
    var isExpanded = false
    
    init(text: String) {
        self.text = text
    }
}
