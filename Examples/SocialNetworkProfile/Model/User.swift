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
    let id: String
    let firstName: String
    let lastName: String
    let imageUrl: URL
    let city: String
    let info: [Info]
    let description: String?
    
    struct Info: Hashable {
        let id: String
        let icon: String
        let value: String
    }
    

}

extension User: ModernDiffable {
    func isEqualToDiffable(_ other: ModernDiffable) -> Bool {
        guard let maybeUser = other as? User else { return false }
        return maybeUser.id == id
    }
    
    var diffId: AnyHashable {
        return id
    }
}

extension User.Info: ModernDiffable {
    func isEqualToDiffable(_ other: ModernDiffable) -> Bool {
        guard let maybeUser = other as? User.Info else { return false }
        return maybeUser == self
    }
    
    var diffId: AnyHashable {
        return id
    }
}
