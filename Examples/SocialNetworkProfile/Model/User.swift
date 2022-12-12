//
//  User.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import Foundation

struct User: Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let imageUrl: URL
    let city: String
    var info: [Info]
    let description: String?
    
    struct Info: Hashable {
        let id: String
        let icon: String
        let value: String
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
