//
//  DatePickerPopup.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/21/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class NumberPickerPopup: UIViewController, PopupContentView, FilterPopup {
    var frameInPopup: CGRect {
        let h: CGFloat = 34 + 250
        return CGRect(x: 0, y: view.bounds.height - h, width: view.bounds.width, height: h)
    }
    
    var scrollView: UIScrollView? { return nil }
    
    var min: Double { return filter.payload.min }
    var max: Double { return filter.payload.max }
    var step: Double { return filter.payload.step }
    
    var filter: NumberFilter!
    
    var onSelect: ((Double, Double) -> Void)?
    
    private var selectedMin: Double? = nil
    private var selectedMax: Double? = nil
    
    lazy var pickerView = UIPickerView()
    
    lazy var numberFormatter: NumberFormatter = {
       let nf = NumberFormatter()
        nf.allowsFloats = true
        nf.usesGroupingSeparator = false
        nf.numberStyle = .decimal
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners()
        view.addSubview(pickerView)
        setupHeaderView(title: filter.title)
        setupToolbar()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        pickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        view.backgroundColor = .systemBackground
        pickerView.backgroundColor = .systemBackground
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reset() {
        selectedMin = nil
        selectedMax = nil
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(0, inComponent: 1, animated: true)
    }
}

extension NumberPickerPopup : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            let _max = selectedMax ?? max
            return Int(((_max - min) / step).rounded(.up)) + 2
        }
        
        if component == 1 {
            let _min = selectedMin ?? min
            return Int(((max - _min) / step).rounded(.up)) + 2
        }
        
        fatalError("incorrect compopent")
    }
}

extension NumberPickerPopup: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            if component == 0 {
                return "от"
            } else {
                return "до"
            }
        }
        
        if component == 0 {
            let value = min + Double(row - 1) * step
            return numberFormatter.string(from: NSNumber(value: value))
        } else {
            let value = max - Double(row - 1) * step
            return numberFormatter.string(from: NSNumber(value: value))
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        defer {
            pickerView.reloadAllComponents()
        }
        if row == 0 {
            if component == 0 {
                selectedMin = nil
            } else {
                selectedMax = nil
            }
            
            return
        }
        
        if component == 0 {
            selectedMin = min + Double(row) * step - step
        } else {
            selectedMax = max - Double(row) * step + step
        }
    }
}
