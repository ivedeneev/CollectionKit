//
//  StringFilterPopup.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/20/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class StringFilterPopup: CollectionViewController, PopupContentView {
    var frameInPopup: CGRect {
        let safeArea: CGFloat = 34
        let height: CGFloat = max(CGFloat(filter.entries.count * 51) + safeArea + 30.0, 300)
        return CGRect(x: 0, y: view.bounds.height - height, width: view.bounds.width, height: height)
    }
    
    var scrollView: UIScrollView? {
        return collectionView
    }
    
    var filter: StringFilter!
    var selectedEntries = Array<SelectableFilterProtocol>()
    
    var onSelect: (([SelectableFilterProtocol]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = false
        
        collectionView.backgroundColor = .systemBackground
        topConstraint.constant = 44
        bottomConstraint.constant = -44
        
        setupHeaderView()
        roundCorners()
        setupToolbar()
        
        let section = CollectionSection()
        
        let selectionStyle: SelectionStyle = filter.multiselect ? .multi : .single
        let viewModels = filter.entries.map { [unowned self] entry -> RadioButtonViewModel in
            let isSelected = self.selectedEntries.contains { $0.id == entry.id }
            return RadioButtonViewModel(filter: entry, initiallySelected: isSelected, selectionStyle: selectionStyle)
        }
        section += viewModels.map { [unowned self] vm in
            return CollectionItem<RadioButtonCell>(item: vm)
                .onSelect { [unowned self] _ in
                    guard let entry = self.filter.entries.first(where: { $0.id == vm.id }) else { return }
                    if self.filter.multiselect {
                        vm.toggle()
                        if let idx = self.selectedEntries.firstIndex(where: { $0.id == vm.id }) {
                            self.selectedEntries.remove(at: idx)
                        } else {
                            self.selectedEntries.append(entry)
                        }
                        
                       
                    } else {
                        vm.toggle()
                        if let id = self.selectedEntries.first?.id {
                            viewModels.first(where: { $0.id == id })?.toggle()
                        }
                        self.selectedEntries.removeAll()
                        self.selectedEntries.append(entry)
                        self.onSelect?(self.selectedEntries)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        }
        
        director += section
        director.reload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onSelect?(selectedEntries)
    }
    
    private func setupHeaderView() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        view.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let titleLabel = UILabel()
        let cancelButton = UIButton()
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = filter.title
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -10).isActive = true
    }
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemPurple
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isTranslucent = false
        view.addSubview(toolbar)
        
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34).isActive = true
        
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil),
        ], animated: false)
    }
    
    @objc func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
