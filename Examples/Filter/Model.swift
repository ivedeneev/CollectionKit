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
    case numRange
    case bool
    case singleInput
    case fromToInput
}

struct StringFilter: Hashable, FilterProtocol {
    let type: FilterType
    let title: String
    let id = UUID().uuidString
    let payload: Payload
    
    struct Payload: Hashable {
        let entries: [StringFilterEntry]
        let multiselect: Bool
    }
}

struct StringFilterEntry: Hashable, SelectableFilterProtocol {
    var title: String { return displayName }
    
    let id = UUID().uuidString
    let displayName: String
}

struct BoolFilter: Hashable, FilterProtocol, SelectableFilterProtocol {
    let type: FilterType = .bool
    let title: String
    let id: String = UUID().uuidString
    let payload: Payload
    
    struct Payload: Hashable {
        let initialySelected: Bool
    }
}

struct NumberFilter: Hashable, FilterProtocol {
    let type: FilterType = .numRange
    let title: String
    let id: String = UUID().uuidString
    let payload: Payload

    struct Payload: Hashable {
        let min: Double
        let max: Double
        let step: Double
        let selectedMin: Double?
        let selectedMax: Double?
    }
}

struct ManualInputFilter: Hashable, FilterProtocol {
    let type: FilterType = .fromToInput
    let title: String
    let id: String = UUID().uuidString
    let payload: Payload
    
    struct Payload: Hashable {
        let fields: [ManualInputField]
    }
}

struct ManualInputField: Hashable {
    let key: String
    let initialValue: String?
}
