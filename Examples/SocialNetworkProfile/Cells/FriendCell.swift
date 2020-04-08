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
        backgroundColor = .systemBackground
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
        avatarImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        avatarImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nameLabel.numberOfLines = 2
        nameLabel.font = .systemFont(ofSize: 13)
    }
}

extension FriendCell: ConfigurableCollectionItem {
    static func estimatedSize(item: User?, boundingSize: CGSize) -> CGSize {
        let w = (boundingSize.width - 2 * 16 - 2 * 8) / 3
        return CGSize(width: w, height: w * 1.3)
    }
    
    func configure(item: User) {
        nameLabel.text = "\(item.lastName)\n\(item.firstName)"
    }
}
