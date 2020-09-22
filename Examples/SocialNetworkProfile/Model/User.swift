//
//  User.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import Foundation
import IVCollectionKit

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

extension User: ModernDiffable {
    func isEqualToDiffable(_ other: ModernDiffable) -> Bool {
        guard let maybeUser = other as? User else { return false }
        return maybeUser == self
    }
}

extension User.Info: ModernDiffable {
    func isEqualToDiffable(_ other: ModernDiffable) -> Bool {
        guard let maybeUser = other as? User.Info else { return false }
        return maybeUser == self
    }
    
    var diffId: AnyHashable {
        return self
    }
}
