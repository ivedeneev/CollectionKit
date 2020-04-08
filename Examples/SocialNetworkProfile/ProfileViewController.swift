//
//  ProfileViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class ProfileViewController: CollectionViewController {
    
    var user: User?
    var friends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        user = User(firstName: "Igor", lastName: "Vedeneev", imageUrl: URL(string: "www.google.ru")!, city: "Moscow", info: [
            User.Info(id: "phone", icon: "phone", value: "7 (999) 999 99 99"),
            User.Info(id: "address", icon: "address", value: "hidden"),
            User.Info(id: "uni", icon: "uni", value: "HSE")])
        
        friends = [User(firstName: "Sergey", lastName: "Petrov", imageUrl: URL(string: "www.google.ru")!, city: "Morshansk", info: []),
                   User(firstName: "Petr", lastName: "Klimov", imageUrl: URL(string:"www.google.ru")!, city: "Kubinka", info: []),
                   User(firstName: "Elena", lastName: "Smirnova", imageUrl: URL(string:"www.google.ru")!, city: "Kubinka", info: []),
                   User(firstName: "Valeria", lastName: "Klimova", imageUrl: URL(string:"www.google.ru")!, city: "Kubinka", info: []),
                   User(firstName: "Viktor", lastName: "Yudaev", imageUrl: URL(string:"www.google.ru")!, city: "Tambov", info: []),
                   User(firstName: "Andy", lastName: "Van der Meyde", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                ]
        configure()
    }
    
    func configure() {
        defer {
            director.performUpdates()
        }
        
        guard let user = user else { return }
        
        let userSection = CollectionSection()
        userSection += CollectionItem<AvatarCell>(item: user)
        userSection.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let infoRows = user.info.map(CollectionItem<ProfileInfoCell>.init)
        userSection += infoRows
        director += userSection
        
        if !friends.isEmpty {
            let friendSection = CollectionSection()
            friendSection.insetForSection = UIEdgeInsets(top: 32, left: 16, bottom: 20, right: 16)
            friendSection.minimumInterItemSpacing = 8
            friendSection.lineSpacing = 8
            
            friendSection += friends.map(CollectionItem<FriendCell>.init)
            
            let buttonVm = ButtonViewModel(icon: nil, title: "See All", handler: { print("yezzzzzzzzz") })
            friendSection.footerItem = CollectionHeaderFooterView<ButtonFooter>(item: buttonVm, kind: UICollectionView.elementKindSectionFooter)
            director += friendSection
        }
        
        /// ... more sections
    }
}
