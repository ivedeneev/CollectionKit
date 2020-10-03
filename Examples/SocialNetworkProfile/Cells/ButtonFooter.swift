//
//  ButtonFooter.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

struct ButtonViewModel: ModernDiffable {
    var diffId: AnyHashable { title }
    
    func isEqualToDiffable(_ other: ModernDiffable) -> Bool {
        guard let buttonVm = other as? ButtonViewModel else { return false }
        return buttonVm.title == title
    }
    
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
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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

