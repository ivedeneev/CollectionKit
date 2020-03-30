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
    /// Assume that nib file name matches class name
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    func dequeue<T: Reusable>(indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("cell type \(T.self) is not registered")
        }
        return cell
    }
    
    func registerNib<T: Reusable>(_ type: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerClass<T: Reusable>(_ type: T.Type) where T: UICollectionViewCell {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
