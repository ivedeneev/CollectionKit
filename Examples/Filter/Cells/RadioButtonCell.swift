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
    var cancellable: Cancellable?
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(white: 0.85, alpha: 1) : .systemBackground
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(radioButtonImageView)
        radioButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

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

extension RadioButtonCell: ConfigurableCollectionItem {
    static func estimatedSize(item: RadioButtonViewModel, boundingSize: CGSize, in section: AbstractCollectionSection) -> CGSize {
        return .init(width: boundingSize.width, height: filterCellHeight)
    }
    
    func configure(item: RadioButtonViewModel) {
        titleLabel.text = item.title
        cancellable = item.output
            .map { [item] in $0 ? item.selectionStyle.onImage : item.selectionStyle.offImage }
            .assign(to: \.image, on: radioButtonImageView)
    }
}

final class RadioButtonViewModel {
    let title: String
    let id: String
    let selectionStyle: SelectionStyle
    lazy var output: AnyPublisher<Bool, Never> = _output.eraseToAnyPublisher()
    private let _output: CurrentValueSubject<Bool, Never>
    
    init(filter: SelectableFilterProtocol, initiallySelected: Bool, selectionStyle: SelectionStyle) {
        self.title = filter.title
        self.id = filter.id
        self.selectionStyle = selectionStyle
        self._output = CurrentValueSubject<Bool, Never>(initiallySelected)
    }
    
    func toggle() {
        _output.send(!_output.value)
    }
}

