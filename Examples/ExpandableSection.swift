//
//  ExpandableSection.swift
//  Examples
//
//  Created by Igor Vedeneev on 10.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import CollectionKit

class ExpandableSection : CollectionSection {
    var isExpanded: Bool = false

    override func numberOfItems() -> Int {
        return isExpanded ? items.count : 3
    }

//    override func reload() {
//
//    }
}

