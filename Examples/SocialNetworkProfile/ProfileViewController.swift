//
//  ProfileViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/18/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class ProfileViewController: CollectionViewController, PopupContentView {
    var frameInPopup: CGRect { return CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height - 50) }
    
    var scrollView: UIScrollView? { return collectionView }
    
    
    var user: User?
    var friends = [User]()
    var posts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(val: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadData(val: 1)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.loadData(val: 2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.77) {
            self.loadData(val: 3)
        }
    }
    
    func loadData(val: Int) {
        switch val {
        case 0:
            user = User(id: "iv", firstName: "Igor", lastName: "Vedeneev", imageUrl: URL(string: "www.google.ru")!, city: "Moscow", info: [], description: nil)
        case 1:
            user = User(id: "iv", firstName: "Igor", lastName: "Vedeneev", imageUrl: URL(string: "www.google.ru")!, city: "Moscow", info: [
            User.Info(id: "phone", icon: "phone", value: "7 (999) 999 99 99"),
            User.Info(id: "address", icon: "address", value: "hidden"),
            User.Info(id: "uni", icon: "uni", value: "HSE")], description: "Leaders of hard-hit states are considering new limits on businesses. Germany is dealing with a surge. President Trump shared a video with misleading coronavirus claims.\n\nRIGHT NOW: New York will now require travelers from Puerto Rico, Washington D.C. and 34 states to quarantine for 14 days, Gov. Andrew M. Cuomo said. The new states added to the list are Illinois, Kentucky and Minnesota.")
        case 2:
            friends = [User(id: "sp", firstName: "Sergey", lastName: "Petrov", imageUrl: URL(string: "www.google.ru")!, city: "Morshansk", info: [], description: nil),
                       User(id: "pk", firstName: "Petr", lastName: "Klimov", imageUrl: URL(string:"www.google.ru")!, city: "Kubinka", info: [], description: nil),
                       User(id: "es", firstName: "Elena", lastName: "Smirnova", imageUrl: URL(string:"www.google.ru")!, city: "Kubinka", info: [], description: nil),
                       User(id: "vk", firstName: "Valeria", lastName: "Klimova", imageUrl: URL(string:"www.google.ru")!, city: "Kubinka", info: [], description: nil),
                       User(id: "vy", firstName: "Viktor", lastName: "Yudaev", imageUrl: URL(string:"www.google.ru")!, city: "Tambov", info: [], description: nil),
                       User(id: "avdm", firstName: "Andy", lastName: "Van der Meyde", imageUrl: URL(string: "www.google.ru")!, city: "Amsterdam", info: [], description: nil),
            ]
            
        case 3:
            user?.info.append(.init(id: "333", icon: "phone", value: "+7 (4752) 52-57-66"))
            friends.insert(User(id: "kr", firstName: "Kristina", lastName: "Test", imageUrl: URL(string: "www.amster.ru")!, city: "Moskva", info: [], description: nil), at: 0)
            
            posts = (0..<20).map {
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                return "\($0)\n" + String((0..<300).map { _ in letters.randomElement()! })
              }
        default:
            break
        }
        
        configure()
    }
    
    func configure() {
        defer {
            director.performUpdates()
        }
        
        let userSection = CollectionSection(id: "user")
        let descriptionSecion = CollectionSection(id: "desc")
        let friendSection = CollectionSection(id: "friend")
        let postsSection = CollectionSection(id: "posts")
        
        var sections = Array<AbstractCollectionSection>()
        guard let user = user else { return }
        title = user.firstName
        
        userSection += CollectionItem<AvatarCell>(item: user).onSelect { [unowned self] (_) in
            self.collectionView.scrollToItem(at: IndexPath(item: 10, section: 3), at: .centeredVertically, animated: true)
        }
        userSection.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        let infoRows = user.info.map(CollectionItem<ProfileInfoCell>.init)
        userSection += infoRows
        sections.append(userSection)
        
        if let desc = user.description {
            descriptionSecion.headerItem = CollectionHeaderFooterView<CollectionHeader>(item: "About me")
            
            let descViewModel = MultilineTextViewModel(text: desc)
            descriptionSecion += CollectionItem<MultilineTextCell>(item: descViewModel)
                .onSelect { [descViewModel, director] _ in
                    descViewModel.isExpanded = !descViewModel.isExpanded
                    director.performUpdates()
                }
            
            descriptionSecion.insetForSection = UIEdgeInsets(top: 0, left: 8, bottom: 16, right: 8)
            
            sections.append(descriptionSecion)
        }
        
        if !friends.isEmpty {
            friendSection.insetForSection = UIEdgeInsets(top: 32, left: 16, bottom: 20, right: 16)
            friendSection.minimumInterItemSpacing = 8
            friendSection.lineSpacing = 8
            
            friendSection += friends.map(CollectionItem<FriendCell>.init)
            
            let buttonVm = ButtonViewModel(icon: nil, title: "See All", handler: { print("yezzzzzzzzz") })
            friendSection.footerItem = CollectionHeaderFooterView<ButtonFooter>(item: buttonVm)
            sections.append(friendSection)
        }
        
        if !posts.isEmpty {
            postsSection.headerItem = CollectionHeaderFooterView<CollectionHeader>(item: "Posts")
            
            postsSection += posts.map { post in
                    let vm = MultilineTextViewModel(text: post)
                    return CollectionItem<MultilineTextCell>(item: vm)
                        .onSelect { [vm, director] _ in
                            vm.isExpanded = !vm.isExpanded
                            director.performUpdates()
                        }
                }
            
            postsSection.insetForSection = UIEdgeInsets(top: 0, left: 8, bottom: 16, right: 8)
            postsSection.lineSpacing = 8
            
            sections.append(postsSection)
        }
        
        director.sections = sections
    }
}
