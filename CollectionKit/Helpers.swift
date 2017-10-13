//
//  Helpers.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 03.10.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation

func +=(left: CollectionDirector, right: CollectionSection) {
    left.append(section: right)
}

func +=(left: CollectionSection, right: AbstractCollectionItem) {
    left.append(item: right)
}

enum NotificationNames : String {
    case reloadSection
    case reloadRow
}
