//
//  Helpers.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 03.10.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Operators
func +=(left: CollectionDirector, right: CollectionSection) {
    left.append(section: right)
}

func +=(left: CollectionSection, right: AbstractCollectionItem) {
    left.append(item: right)
}

enum NotificationNames : String {
    case reloadSection
    case reloadRow
    case insertItem
    case removeItem
}


//MARK:- Convinience
extension UICollectionView {
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

public protocol ConfigurableCollectionItem : Reusable {
    associatedtype T
    static func estimatedSize(item: T?) -> CGSize
    func configure(item: T)
}


//MARK:- ActionableCollectionItem
public protocol ActionableCollectionItem {
    var onSelect: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onDeselect: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onDisplay: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onEndDisplay: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onHighlight: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onUnighlight: ((_ indexPath: IndexPath) -> Void)? { get set }
    var shouldHighlight: Bool? { get set }
}




//MARK:- AbstractCollectionItem
public protocol AbstractCollectionItem : ActionableCollectionItem {
    var reuseIdentifier: String { get }
    var estimatedSize: CGSize { get }
    func configure(_: UICollectionReusableView)
}
