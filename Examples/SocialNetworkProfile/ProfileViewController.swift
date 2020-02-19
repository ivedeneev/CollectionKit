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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        user = User(firstName: "Igor", lastName: "Vedeneev", imageUrl: URL(string: "www.google.ru")!, city: "Moscow", info: [
            User.Info(id: "phone", icon: "phone", value: "7 (999) 999 99 99"),
            User.Info(id: "address", icon: "address", value: "hidden"),
            User.Info(id: "uni", icon: "uni", value: "HSE")])
        configure()
    }
    
    func configure() {
        if let user = user {
            let userSection = CollectionSection()
            userSection += CollectionItem<AvatarCell>(item: user)
            userSection.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            let infoRows = user.info.map(CollectionItem<ProfileInfoCell>.init)
            userSection += infoRows
            director += userSection
            
            let friendSection = CollectionSection()
            friendSection.insetForSection = UIEdgeInsets(top: 32, left: 16, bottom: 20, right: 16)
            friendSection.minimumInterItemSpacing = 8
            friendSection.lineSpacing = 8
            
            friendSection += CollectionItem<FriendCell>(item: user)
            friendSection += CollectionItem<FriendCell>(item: user)
            friendSection += CollectionItem<FriendCell>(item: user)
            friendSection += CollectionItem<FriendCell>(item: user)
            friendSection += CollectionItem<FriendCell>(item: user)
            friendSection += CollectionItem<FriendCell>(item: user)
            
            let buttonVm = ButtonViewModel(icon: nil, title: "See All", handler: { print("yezzzzzzzzz") })
            friendSection.footerItem = CollectionHeaderFooterView<ButtonFooter>(item: buttonVm, kind: UICollectionView.elementKindSectionFooter)
            director += friendSection
        }
        
        director.performUpdates()
    }
}
