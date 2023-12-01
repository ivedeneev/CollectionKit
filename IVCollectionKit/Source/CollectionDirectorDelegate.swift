//
//  CollectionDirectorDelegate.swift
//  IVCollectionKit
//
//  Created by Igor Vedeneev on 25.11.2023.
//  Copyright © 2023 Igor Vedeneev. All rights reserved.
//

import Foundation

public protocol CollectionDirectorDelegate: AnyObject {
    func didScrollToBottom(director: CollectionDirector)
}
