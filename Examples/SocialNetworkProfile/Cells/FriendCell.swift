//
//  FriendCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class FriendCell: UICollectionViewCell {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemGroupedBackground
        clipsToBounds = true
        layer.cornerRadius = 8
        setupAvatarImageView()
        setupNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.backgroundColor = .systemFill
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor),
            avatarImageView.rightAnchor.constraint(equalTo: rightAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        

        nameLabel.numberOfLines = 2
        nameLabel.font = .systemFont(ofSize: 13)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FriendCell: ConfigurableCollectionItem {
    static func estimatedSize(item: User, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        let w = (boundingSize.width - 2 * section.insetForSection.left - 2 * section.minimumInterItemSpacing) / 3
        return CGSize(width: w, height: w * 1.3)
    }
    
    func configure(item: User) {
        nameLabel.text = "\(item.lastName)\n\(item.firstName)"
    }
}
