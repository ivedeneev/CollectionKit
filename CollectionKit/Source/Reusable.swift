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

public extension UICollectionView {
    func dequeue<T: Reusable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerNib<T: Reusable>(_ type: T.Type) {
        self.register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerClass<T: Reusable>(_ type: T.Type) where T:UICollectionViewCell {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
