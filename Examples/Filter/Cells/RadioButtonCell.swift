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
        radioButtonImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        radioButtonImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        radioButtonImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        radioButtonImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: radioButtonImageView.leftAnchor, constant: -10).isActive = true
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

final class RadioButtonViewModel: ModernDiffable {
    var diffId: AnyHashable { return id }
    
    func isEqualToDiffable(_ other: ModernDiffable) -> Bool {
        guard let maybeRadio = other as? RadioButtonViewModel else {
            return false
        }
        
        return maybeRadio.id == id
    }
    
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

