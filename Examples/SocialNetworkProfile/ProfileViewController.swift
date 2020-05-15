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
    
    let userSection = CollectionSection()
    let friendSection = CollectionSection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .refresh, target: self, action: #selector(removeLast))
        
        let refreshControl = UIRefreshControl()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func removeLast() {
        friends = friends.dropLast()
        configure()
    }
    
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.friends = self.friends.dropLast()
            self.configure()
            self.collectionView.refreshControl?.endRefreshing()
        }
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
                   User(firstName: "Viktoria", lastName: "Hanina", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Vladimir", lastName: "Merzlikin", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Andrey", lastName: "Kozlov", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Natalia", lastName: "Poklonskaya", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Anastasia", lastName: "Gordone", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Alex", lastName: "Souza", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Simon", lastName: "Hz", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Dmitriy", lastName: "Gordon", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Timofey", lastName: "Kalachev", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: []),
                   User(firstName: "Barsik", lastName: "Meow", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: [])
                ]
        configure()
    }
    
    func configure() {
        defer {
            director.performUpdates()
        }
        
        guard let user = user else { return }
        
        director.removeAll(clearSections: true)
        
       
        userSection += CollectionItem<AvatarCell>(item: user)
        userSection.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let infoRows = user.info.map(CollectionItem<ProfileInfoCell>.init)
        userSection += infoRows
        director += userSection
        
        if !friends.isEmpty {
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
