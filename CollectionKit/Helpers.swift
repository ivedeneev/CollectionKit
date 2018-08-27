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
    print("CollectionKit: \(logLevel.description.uppercased()): \(message)")
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

public func ==(lhs: AbstractCollectionSection, rhs: AbstractCollectionSection) -> Bool {
    return lhs.identifier == rhs.identifier
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

func postInsertOrDeleteItemNotification(section: AbstractCollectionSection, indicies: [Int], action: UpdateActionType) {
    NotificationCenter.default.post(name: Notification.Name(rawValue: CKInsertOrDeleteNotificationName),
                                    object: nil,
                                    userInfo: [ CKUpdateActionKey    : action,
                                                CKTargetSectionKey   : section,
                                                CKItemIndexKey       : indicies ])
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
//    case supplementaryView
}

struct ItemUpdate : AbstractCollectionUpdate {
    init(indexPath: IndexPath, type: UpdateActionType) {
        self.indexPaths = [ indexPath ]
        self.type = type
    }
    
    init(indexPaths: [IndexPath], type: UpdateActionType) {
        self.indexPaths = indexPaths
        self.type = type
    }
    
    let indexPaths: [IndexPath]
    let type: UpdateActionType
}

struct SectionUpdate : AbstractCollectionUpdate {
    init(indicies: [Int], type: UpdateActionType) {
        self.indicies = indicies
        self.type = type
    }
    
    init(index: Int, type: UpdateActionType) {
        self.indicies = [ index ]
        self.type = type
    }
    
    let indicies: [Int]
    let type: UpdateActionType
}

struct SupplementaryViewUpdate : AbstractCollectionUpdate {
    let type: UpdateActionType
    let kind: String
    let indexPath: IndexPath
}

protocol AbstractCollectionUpdate {
    var type: UpdateActionType { get }
}

//MARK:- Convinience
extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}

