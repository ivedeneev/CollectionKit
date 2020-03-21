//
//  FilterViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/2/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit
import Combine

final class FilterViewController: CollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s1 = CollectionSection()
        s1.lineSpacing = 1
        s1.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        director += s1
        
        let s2 = CollectionSection()
        s2.lineSpacing = 1
        
        let filters: [FilterProtocol] = [
            StringFilter(type: .singleSelect, title: "Владельцев по ПТС", entries: ["Один", "Не более двух"].map(StringFilterEntry.init), multiselect: false),
            StringFilter(type: .singleSelect, title: "Коробка", entries: ["Автомат", "Механика"].map(StringFilterEntry.init), multiselect: true),
            StringFilter(type: .singleSelect, title: "Привод", entries: ["Передний", "Полный", "Задний"].map(StringFilterEntry.init), multiselect: true),
            StringFilter(type: .singleSelect, title: "Расположение руля", entries: ["Левый", "Правый"].map(StringFilterEntry.init), multiselect: false)
        ]
        
        s2 += filters.map { filter in
            let vm = TextSelectViewModel(filter: filter)
            return CollectionItem<FilterTextValueCell>(item: vm).onSelect { [weak self] (_) in
                let vc: UIViewController
                switch filter.type {
                case .singleSelect, .multiSelect:
                    let _vc = PopupController<StringFilterPopup>()
                    vc = _vc
                    _vc.content.selectedEntries = vm.currentValue()
                    _vc.content.filter = filter as! StringFilter
                    _vc.content.onSelect = { [unowned vm] entries in
                        vm.updateSelection(entries)
                    }
                case .dateRange:
                    vc = UITableViewController()
                default:
                    vc = UITableViewController()
                }
                
                self?.present(vc, animated: true, completion: nil)
            }
        }
        s2.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        director += s2
        
        let s3 = CollectionSection()
        s3.lineSpacing = 1
        s3.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        director += s3
        
        
        let boolFilters = [
            BoolFilter(title: "На гарантии", initialySelected: false),
            BoolFilter(title: "Только с фото", initialySelected: true)
        ]
        
        s3 += boolFilters.map { filter in
            let vm = RadioButtonViewModel(filter: filter, initiallySelected: filter.initialySelected, selectionStyle: .multi)
            return CollectionItem<RadioButtonCell>(item: vm)
                .onSelect { _ in
                    vm.toggle()
                }
        }
        
        director.reload()
    }
}
