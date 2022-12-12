//
//  ManualInputFilterPopup.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/22/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class ManualInputFilterPopup: CollectionViewController, PopupContentView, FilterPopup {
    
    var frameInPopup: CGRect {
        let safeArea: CGFloat = 34
        let height: CGFloat = max(CGFloat(filter.payload.fields.count * 51) + safeArea + 30.0, 250)
        return CGRect(x: 0, y: view.bounds.height - height, width: view.bounds.width, height: height)
    }
    
    var scrollView: UIScrollView? {
        return collectionView
    }
    
    var filter: ManualInputFilter!
    var selectedEntries = Array<SelectableFilterProtocol>()
    
    var onSelect: (([SelectableFilterProtocol]) -> Void)?
    
    var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardObserving()
        setupHeaderView(title: filter.title)
        roundCorners()
    
        let fields = filter.payload.fields.map { field -> UITextField in
            let tf = FloatingLabelTextField()
            tf.kg_placeholder = field.key
            tf.keyboardType = .decimalPad
            return tf
        }
        
        
        stackView = UIStackView(arrangedSubviews: fields)
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (stackView.arrangedSubviews.first as? UITextField)?.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reset() {
        print("reset")
    }
}
