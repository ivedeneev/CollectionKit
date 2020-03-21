//
//  FilterTextValueCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/2/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit
import Combine

final class FilterTextValueCell: UICollectionViewCell {
    private let textField = FloatingLabelTextField()
    private var cancellable: Cancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
        textField.showUnderlineView = false
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cancellable?.cancel()
    }
}

extension FilterTextValueCell: ConfigurableCollectionItem {
    static func estimatedSize(item: TextSelectViewModel?, boundingSize: CGSize) -> CGSize {
        return .init(width: boundingSize.width, height: filterCellHeight)
    }
    
    func configure(item: TextSelectViewModel) {
        cancellable = item.output.assign(to: \.text, on: textField)
        textField.kg_placeholder = item.title
    }
}

protocol FilterEntryProtocol {
//    func transform(newValue: Input) -> Output
    var title: String { get }
//    var input: CurrentValueSubject<Input, Never> { get }
    var output: AnyPublisher<String?, Never> { get }
//    var filterType: FilterType { get }
//    var filterId: String { get }
}



final class TextSelectViewModel {
    let title: String
    let id: String
    lazy var output: AnyPublisher<String?, Never> = _output
        .map { entries -> String in
            return entries.reduce(into: "", {
                if !$0.isEmpty {
                    $0.append(", ")
                }
                $0.append($1.title) })
    }.eraseToAnyPublisher()
    private let _output = CurrentValueSubject<[SelectableFilterProtocol], Never>([])
    
    init(filter: FilterProtocol) {
        self.title = filter.title
        self.id = filter.id
    }
    
    func updateSelection(_ entries: [SelectableFilterProtocol]) {
        _output.send(entries)
    }
    
    func currentValue() -> [SelectableFilterProtocol] {
        return _output.value
    }
}
