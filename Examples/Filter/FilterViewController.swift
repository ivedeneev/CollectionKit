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
    
    let df: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy"
        return d
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s1 = CollectionSection()
        s1.lineSpacing = 1
        s1.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        director += s1
        
        let s2 = CollectionSection()
        s2.lineSpacing = 1
        
        let filters: [FilterProtocol] = [
            StringFilter(type: .singleSelect, title: "Владельцев по ПТС", payload: StringFilter.Payload(entries: ["Один", "Не более двух"].map(StringFilterEntry.init), multiselect: false)),
            NumberFilter(title: "Год выпуска", payload: NumberFilter.Payload(min: 1890, max: 2020, step: 1, selectedMin: nil, selectedMax: nil)),
            NumberFilter(title: "Объем двигателя", payload: NumberFilter.Payload(min: 0.2, max: 4.4, step: 0.1, selectedMin: nil, selectedMax: nil)),
            StringFilter(type: .singleSelect, title: "Коробка", payload: StringFilter.Payload(entries: ["Автомат", "Механика"].map(StringFilterEntry.init), multiselect: true)),
            StringFilter(type: .singleSelect, title: "Привод", payload: StringFilter.Payload(entries: ["Передний", "Полный", "Задний"].map(StringFilterEntry.init), multiselect: true)),
            StringFilter(type: .singleSelect, title: "Расположение руля", payload: StringFilter.Payload(entries: ["Левый", "Правый"].map(StringFilterEntry.init), multiselect: false)),
            ManualInputFilter(title: "Цена", payload: .init(fields: [.init(key: "от", initialValue: nil), .init(key: "до", initialValue: nil)]))
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
                case .numRange:
                    let _vc = PopupController<NumberPickerPopup>()
                    vc = _vc
//                    _vc.content.selectedEntries = vm.currentValue()
                    _vc.content.filter = filter as! NumberFilter
//                    _vc.content.onSelect = { [unowned vm] entries in
//                        vm.updateSelection(entries)
//                    }
                case .fromToInput:
                    let _vc = PopupController<ManualInputFilterPopup>()
                    vc = _vc
//                    _vc.content.selectedEntries = vm.currentValue()
                    _vc.content.filter = filter as! ManualInputFilter
//                    _vc.content.onSelect = { [unowned vm] entries in
//                        vm.updateSelection(entries)
//                    }
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
            BoolFilter(title: "На гарантии", payload: .init(initialySelected: false)),
            BoolFilter(title: "Только с фото", payload: .init(initialySelected: true))
        ]
        
        s3 += boolFilters.map { filter in
            let vm = RadioButtonViewModel(filter: filter, initiallySelected: filter.payload.initialySelected, selectionStyle: .multi)
            return CollectionItem<RadioButtonCell>(item: vm)
                .onSelect { _ in
                    vm.toggle()
                }
        }
        
        director.reload()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            let verticalContentSize = self.director.calculateContentSize(for: .vertical)
            print(">>> ", verticalContentSize)
        }
    }
}


final class TestPopup: UIViewController, PopupContentView {
    var frameInPopup: CGRect {
        return .init(x: 0, y: 150, width: view.bounds.width, height: view.bounds.height - 150)
    }
    
    var scrollView: UIScrollView? { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorners()
        view.backgroundColor = .systemBlue
    }
}
