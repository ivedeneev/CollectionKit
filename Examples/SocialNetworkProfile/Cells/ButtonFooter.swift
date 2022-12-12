//
//  ButtonFooter.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

struct ButtonViewModel {
    let icon: String?
    let title: String
    let handler: (() -> Void)
}

final class ButtonFooter: UICollectionReusableView {
    private let button = UIButton.init(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ButtonFooter: ConfigurableCollectionItem {
    static func estimatedSize(item: ButtonViewModel, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        return CGSize(width: boundingSize.width, height: 40)
    }
    
    func configure(item: ButtonViewModel) {
        button.setTitle(item.title, for: .normal)
    }
}

