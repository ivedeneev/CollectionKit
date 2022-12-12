//
//  StringFilterPopup.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/20/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class StringFilterPopup: CollectionViewController, PopupContentView, FilterPopup {
    
    var frameInPopup: CGRect {
        let safeArea: CGFloat = 34
        let height: CGFloat = max(CGFloat(filter.payload.entries.count * 51) + safeArea + 30.0, 300)
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
        
        setupHeaderView(title: filter.title)
        roundCorners()
        setupToolbar()
        
        let section = CollectionSection()
        
        let selectionStyle: SelectionStyle = filter.payload.multiselect ? .multi : .single
        let viewModels = filter.payload.entries.map { [unowned self] entry -> RadioButtonViewModel in
            let isSelected = self.selectedEntries.contains { $0.id == entry.id }
            return RadioButtonViewModel(filter: entry, initiallySelected: isSelected, selectionStyle: selectionStyle)
        }
        section += viewModels.map { [unowned self] vm in
            return CollectionItem<RadioButtonCell>(item: vm)
                .onSelect { [unowned self] _ in
                    guard let entry = self.filter.payload.entries.first(where: { $0.id == vm.id }) else { return }
                    if self.filter.payload.multiselect {
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
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reset() {
        print("reset")
    }
}
