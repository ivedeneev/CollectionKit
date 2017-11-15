//
//  Reusable.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit.UINib

public protocol Reusable {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
