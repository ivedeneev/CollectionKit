//
//  CollectionSectionAdapter.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 3/12/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import Foundation

protocol CollectionSectionAdapter {
    func collectionSection() -> AbstractCollectionSection
    var isEmpty: Bool { get }
}
