//
//  AvatarCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class AvatarCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let ageAndCityLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        setupImageView()
        setupNameLabel()
        setupAgeAndCityLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private func setupAgeAndCityLabel() {
        addSubview(ageAndCityLabel)
        ageAndCityLabel.translatesAutoresizingMaskIntoConstraints = false
        ageAndCityLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2).isActive = true
        ageAndCityLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        ageAndCityLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        ageAndCityLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        ageAndCityLabel.textColor = .systemGray
        ageAndCityLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
}

extension AvatarCell: ConfigurableCollectionItem {
    static func estimatedSize(item: User, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
         return CGSize.init(width: boundingSize.width, height: 76)
    }
    
    func configure(item: User) {
        nameLabel.text = "\(item.firstName) \(item.lastName)"
        ageAndCityLabel.text = "26 y. \(item.city)"
    }
}
