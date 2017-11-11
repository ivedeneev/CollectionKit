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
public func +=(left: CollectionDirector, right: CollectionSection) {
    left.append(section: right)
}

public func +=(left: CollectionSection, right: AbstractCollectionItem) {
    left.append(item: right)
}

public func ==(left: AbstractCollectionItem, right: AbstractCollectionItem) -> Bool {
    return left.identifier == right.identifier
}

enum NotificationNames : String {
    case reloadSection
    case reloadRow
    case sectionChanges
}

enum CollectionChange : String {
    case insertItem
    case removeItem
    case reloadItem
    case insertSection
    case removeSection
}


//MARK:- Convinience
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

public protocol ConfigurableCollectionItem : Reusable {
    associatedtype T
    static func estimatedSize(item: T?) -> CGSize
    func configure(item: T)
}


//MARK:- ActionableCollectionItem
//TODO: consider indexpath , item, cell as parameter
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
    var identifier: String { get }
    func configure(_: UICollectionReusableView)
}
