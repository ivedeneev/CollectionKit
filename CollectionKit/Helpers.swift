//
//  Helpers.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 03.10.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit

enum LogLevel: CustomStringConvertible {
    case warning
    case error
    
    var description: String {
        switch self {
        case .warning:
            return "warning"
        case .error:
            return "error"
        }
    }
}

func log(_ message: String, logLevel: LogLevel = .warning) {
    print("CollectionKit: \(logLevel.description): \(message)")
}

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

//MARK:- Notifications
let CKReloadNotificationName = "com.collection_kit.reload"
let CKInsertOrDeleteNotificationName = "com.collection_kit.insert_or_delete_item"

let CKUpdateSubjectKey = "subject"
let CKUpdateActionKey = "action"
let CKTargetSectionKey = "section"
let CKItemIndexKey = "index"

func postReloadNotofication(subject: UpdateSubject, object: Any) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: CKReloadNotificationName),
                                    object: object,
                                    userInfo: [ CKUpdateSubjectKey : subject,
                                                CKUpdateActionKey  : UpdateActionType.reload ])
}

func postInsertOrDeleteItemNotification(section: AbstractCollectionSection, index: Int, action: UpdateActionType) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: CKInsertOrDeleteNotificationName),
                                    object: nil,
                                    userInfo: [ CKUpdateActionKey    : action,
                                                CKTargetSectionKey   : section,
                                                CKItemIndexKey       : index ])
}


//MARK:- Update models
enum UpdateActionType {
    case insert
    case delete
    case reload
}

enum UpdateSubject : String {
    case item
    case section
}

//todo: consider using arrays
struct ItemChange : AbstractCollectionUpdate {
    let indexPath: IndexPath
    let type: UpdateActionType
}

struct SectionUpdate : AbstractCollectionUpdate {
    let index: Int
    let type: UpdateActionType
}

protocol AbstractCollectionUpdate {
    var type: UpdateActionType { get }
}

//MARK:- Convinience


//MARK:- ConfigurableCollectionItem
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
    var onDisplay: ((_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void)? { get set }
    var onEndDisplay: ((_ indexPath: IndexPath, _ cell: UICollectionViewCell) -> Void)? { get set }
    var onHighlight: ((_ indexPath: IndexPath) -> Void)? { get set }
    var onUnighlight: ((_ indexPath: IndexPath) -> Void)? { get set }
    var shouldHighlight: Bool? { get set }
}


//MARK:- AbstractCollectionItem
public protocol AbstractCollectionItem : ActionableCollectionItem {
    var reuseIdentifier: String { get }
    var estimatedSize: CGSize { get }
    var identifier: String { get }
    var cellType: AnyClass { get }
    func configure(_: UICollectionReusableView)
}
