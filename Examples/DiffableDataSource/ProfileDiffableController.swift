//
//  ProfileDiffableController.swift
//  Examples
//
//  Created by Igor Vedeneev on 10/10/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit

final class ProfileDiffableController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case user
        case about
        case friends
        
        var columnCount: Int {
            switch self {
            case .friends:
                return 3
            default:
                return 1
            }
        }
    }
    
    enum Item: Hashable {
        case avatar(User)
        case userInfo(User.Info)
        case about(MultilineTextViewModel)
        case friend(User)
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    var user: User?
    var friends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "NSDifffableDataSource"
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.registerClass(AvatarCell.self)
        collectionView.registerClass(ProfileInfoCell.self)
        collectionView.registerClass(MultilineTextCell.self)
        collectionView.registerClass(FriendCell.self)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadData(val: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadData(val: 1)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.loadData(val: 2)
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
        default:
            break
        }
        
        configure()
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (cv, ip, item) -> UICollectionViewCell? in
                switch item {
                case .avatar(let user):
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: AvatarCell.reuseIdentifier, for: ip) as? AvatarCell
                    cell?.configure(item: user)
                    return cell
                case .userInfo(let userInfo):
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: ProfileInfoCell.reuseIdentifier, for: ip) as? ProfileInfoCell
                    cell?.configure(item: userInfo)
                    return cell
                case .about(let textVm):
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: MultilineTextCell.reuseIdentifier, for: ip) as? MultilineTextCell
                    cell?.configure(item: textVm)
                    return cell
                case .friend(let user):
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: FriendCell.reuseIdentifier, for: ip) as? FriendCell
                    cell?.configure(item: user)
                    return cell
                }
            }
        )
        
        return dataSource
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let columns = sectionKind.columnCount

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight = columns == 1 ?
                NSCollectionLayoutDimension.absolute(44) :
                NSCollectionLayoutDimension.fractionalWidth(0.2)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
            return section
        }
        return layout
    }
    
    func configure() {
        guard let user = self.user else { return }
        var snapshot = Snapshot()
        
        snapshot.appendSections([.user])
        snapshot.appendItems([.avatar(user)] + user.info.map { Item.userInfo($0) }, toSection: .user)
        
        if let desc = user.description {
            snapshot.appendSections([.about])
            let vm = MultilineTextViewModel(text: desc)
            snapshot.appendItems([Item.about(vm)], toSection: .about)
        }
        
        if !friends.isEmpty {
            snapshot.appendSections([.friends])
            snapshot.appendItems(friends.map { Item.friend($0) }, toSection: .friends)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ProfileDiffableController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                return CGSize(width: width, height: 76)
            default:
                return CGSize(width: width, height: 30)
            }
        case 1:
            return CGSize(width: width - 32, height: 100)
        case 2:
            let w = (width - 2 * 16 - 2 * 8) / 3
            return CGSize(width: w, height: w * 1.3)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 2:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 2:
            return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        case 1:
            return UIEdgeInsets(top: 0, left: 8, bottom: 16, right: 8)
        case 2:
            return UIEdgeInsets(top: 32, left: 16, bottom: 20, right: 16)
        default:
            return .zero
        }
    }
}
