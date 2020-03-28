//
//  SectionProvider.swift
//  IVCollectionKit
//
//  Created by Igor Vedeneev on 3/28/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import Foundation

public protocol SectionProvider: class {
    func numberOfSections() -> Int
    func section(for index: Int) -> AbstractCollectionSection
}
