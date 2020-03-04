//
//  FilterViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/2/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class FilterViewController: CollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s1 = CollectionSection()
        s1.lineSpacing = 1
        s1 += CollectionItem<FilterTextValueCell>(item: TextSelectViewModel(title: "Тест", id: "ffffffff"))
        s1 += CollectionItem<FilterTextValueCell>(item: TextSelectViewModel(title: "Ну типа", id: "fdfds"))
        s1 += CollectionItem<RadioButtonCell>(item: RadioButtonViewModel(title: "Radio", id: "-_-0000"))
        s1.insetForSection = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        director += s1
        
        let s2 = CollectionSection()
        s2.lineSpacing = 1
        s2 += CollectionItem<FilterTextValueCell>(item: TextSelectViewModel(title: "Тип двигателя", id: "ffffffff"))
        s2 += CollectionItem<FilterTextValueCell>(item: TextSelectViewModel(title: "Коробка передач", id: "fdfds"))
        s2 += CollectionItem<RadioButtonCell>(item: RadioButtonViewModel(title: "Есть кондиционер", id: "-_-0000"))
        s2.insetForSection = UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
        director += s2
        
        director.reload()
    }
}
