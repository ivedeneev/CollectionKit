//
//  Operators.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 27/08/2018.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation

public func +=(left: CollectionDirector, right: AbstractCollectionSection) {
    left.append(section: right)
}

public func +=(left: AbstractCollectionSection, right: AbstractCollectionItem) {
    left.append(item: right)
}

public func +=(left: CollectionDirector, right: [AbstractCollectionSection]) {
    left.append(sections: right)
}

public func +=(left: AbstractCollectionSection, right: [AbstractCollectionItem]) {
    left.append(items: right)
}

public func ==(left: AbstractCollectionItem, right: AbstractCollectionItem) -> Bool {
    return left.identifier == right.identifier
}

public func ==(lhs: AbstractCollectionSection, rhs: AbstractCollectionSection) -> Bool {
    return lhs.identifier == rhs.identifier
}
