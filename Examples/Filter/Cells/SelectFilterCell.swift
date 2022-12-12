//
//  SelectFilterCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/21/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit
import Combine


final class SelectFilterCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let radioButtonImageView = UIImageView()
    var cancellable: Cancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(radioButtonImageView)
        radioButtonImageView.translatesAutoresizingMaskIntoConstraints = false

        radioButtonImageView.contentMode = .scaleAspectFit
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            radioButtonImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            radioButtonImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioButtonImageView.widthAnchor.constraint(equalToConstant: 18),
            radioButtonImageView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.rightAnchor.constraint(equalTo: radioButtonImageView.leftAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cancellable?.cancel()
        cancellable = nil
    }
}

extension SelectFilterCell: ConfigurableCollectionItem {
    static func estimatedSize(item: SelectFilterCellViewModel, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
         return .init(width: boundingSize.width, height: filterCellHeight)
    }
    
    func configure(item: SelectFilterCellViewModel) {
        titleLabel.text = item.title
        cancellable = item.output
            .map { $0 ? UIImage(named: "checkmark") : nil }
            .assign(to: \.image, on: radioButtonImageView)
    }
}

final class SelectFilterCellViewModel {
    let title: String
    let id: String
    lazy var output: AnyPublisher<Bool, Never> = _output.eraseToAnyPublisher()
    private let _output: CurrentValueSubject<Bool, Never>
    
    init(title: String, id: String, initiallySelected: Bool) {
        self.title = title
        self.id = id
        self._output = CurrentValueSubject<Bool, Never>(initiallySelected)
    }
}
