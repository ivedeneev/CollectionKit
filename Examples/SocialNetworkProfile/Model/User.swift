//
//  User.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import Foundation

struct User: Hashable {
    let id: String = UUID().uuidString
    let firstName: String
    let lastName: String
    let imageUrl: URL
    let city: String
    let info: [Info]
    
    struct Info: Hashable {
        let id: String
        let icon: String
        let value: String
    }
}
