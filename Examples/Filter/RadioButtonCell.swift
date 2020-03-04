//
//  RadioButtonCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/3/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit
import Combine

let filterCellHeight: CGFloat = 56

final class RadioButtonCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let radioButtonImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(radioButtonImageView)
        radioButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        radioButtonImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        radioButtonImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        radioButtonImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        radioButtonImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        radioButtonImageView.clipsToBounds = true
        radioButtonImageView.layer.borderWidth = 1
        radioButtonImageView.layer.cornerRadius = 9
        radioButtonImageView.layer.borderColor = UIColor.separator.cgColor
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: radioButtonImageView.leftAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RadioButtonCell: ConfigurableCollectionItem {
    static func estimatedSize(item: RadioButtonViewModel?, boundingSize: CGSize) -> CGSize {
        return .init(width: boundingSize.width, height: filterCellHeight)
    }
    
    func configure(item: RadioButtonViewModel) {
        titleLabel.text = item.title
    }
}

final class RadioButtonViewModel {
    let title: String
    let id: String
    lazy var output: AnyPublisher<Bool, Never> = _output.eraseToAnyPublisher()
    private let _output = CurrentValueSubject<Bool, Never>.init(false)
    
    init(title: String, id: String) {
        self.title = title
        self.id = id
    }
}

