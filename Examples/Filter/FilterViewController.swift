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
            StringFilter(type: .singleSelect, title: "Previous owners", payload: StringFilter.Payload(entries: ["One", "Two or less"].map(StringFilterEntry.init), multiselect: false)),
            NumberFilter(title: "Year", payload: NumberFilter.Payload(min: 1890, max: 2020, step: 1, selectedMin: nil, selectedMax: nil)),
            NumberFilter(title: "Engine", payload: NumberFilter.Payload(min: 0.2, max: 4.4, step: 0.1, selectedMin: nil, selectedMax: nil)),
            StringFilter(type: .singleSelect, title: "Transmission", payload: StringFilter.Payload(entries: ["Automatic", "Manual"].map(StringFilterEntry.init), multiselect: true)),
            StringFilter(type: .singleSelect, title: "Drive", payload: StringFilter.Payload(entries: ["Front wheel", "Four wheel", "Rear wheel"].map(StringFilterEntry.init), multiselect: true)),
            StringFilter(type: .singleSelect, title: "Steering wheel position", payload: StringFilter.Payload(entries: ["Left side", "Right side"].map(StringFilterEntry.init), multiselect: false)),
            ManualInputFilter(title: "Price", payload: .init(fields: [.init(key: "from", initialValue: nil), .init(key: "to", initialValue: nil)]))
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
                    _vc.content.filter = filter as! NumberFilter
                case .fromToInput:
                    let _vc = PopupController<ManualInputFilterPopup>()
                    vc = _vc
                    _vc.content.filter = filter as! ManualInputFilter
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
            BoolFilter(title: "With warranty", payload: .init(initialySelected: false)),
            BoolFilter(title: "With photo", payload: .init(initialySelected: true))
        ]
        
        s3 += boolFilters.map { filter in
            let vm = RadioButtonViewModel(filter: filter, initiallySelected: filter.payload.initialySelected, selectionStyle: .multi)
            return CollectionItem<RadioButtonCell>(item: vm)
                .onSelect { _ in
                    vm.toggle()
                }
        }
        
        director.reload()
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
