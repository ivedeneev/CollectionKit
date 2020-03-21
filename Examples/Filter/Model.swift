//
//  Model.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/21/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol FilterProtocol {
    var type: FilterType { get }
    var title: String { get }
    var id: String { get }
}

protocol SelectableFilterProtocol {
    var id: String { get }
    var title: String { get }
}


enum SelectionStyle {
    case single
    case multi
    
    var onImage: UIImage? {
        switch self {
        case .multi:
            return UIImage(named: "select_on")
        case .single:
            return UIImage(named: "checkmark")
        }
    }
    
    var offImage: UIImage? {
        switch self {
        case .multi:
            return UIImage(named: "select_off")
        case .single:
            return nil
        }
    }
}

enum FilterType {
    case singleSelect
    case multiSelect
    case dateRange//(Date, Date)
    case numRange//(Float, Float)
    case bool
}

struct StringFilter: Hashable, FilterProtocol {
    let type: FilterType
    let title: String
    let id = UUID().uuidString
    let entries: [StringFilterEntry]
    let multiselect: Bool
}

struct BoolFilter: Hashable, FilterProtocol, SelectableFilterProtocol {
//    var selectionType: SelectionStyle = .single
    
    let type: FilterType = .bool
    let title: String
    let id: String = UUID().uuidString
    let initialySelected: Bool
}

struct StringFilterEntry: Hashable, SelectableFilterProtocol {
    var title: String { return displayName }
    
    let id = UUID().uuidString
    let displayName: String
}
