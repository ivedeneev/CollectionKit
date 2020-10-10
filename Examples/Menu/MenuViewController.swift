//
//  MenuViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/16/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

extension UINavigationController: PopupContentView {
    var frameInPopup: CGRect { return CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height - 50) }
    var scrollView: UIScrollView? { return (viewControllers.last as? PopupContentView)?.scrollView }
}

final class MenuViewController: CollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        let cells = CollectionItem<TextCell>(item: "Multiple cells").adjustsWidth(true).onSelect { [weak self] (_) in
            self?.navigationController?.pushViewController(ViewController(), animated: true)
        }
        
        let social = CollectionItem<TextCell>(item: "Social profile").adjustsWidth(true).onSelect { [weak self] (_) in
            self?.navigationController?.pushViewController(ProfileViewController(), animated: true)
        }
        
        let filter = CollectionItem<TextCell>(item: "Complex filter").adjustsWidth(true).onSelect { [weak self] (_) in
            self?.navigationController?.pushViewController(FilterViewController(), animated: true)
        }
        
        let s1 = CollectionSection(items: [cells, social, filter])
        s1.lineSpacing = 1
        s1.headerItem = CollectionHeaderFooterView<CollectionHeader>(item: "Complex", kind: UICollectionView.elementKindSectionHeader)
        s1.insetForSection = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        director += s1
        
        
        let photos = CollectionItem<TextCell>(item: "Custom Section (photo grid)").adjustsWidth(true).onSelect { [weak self] (_) in
            self?.navigationController?.pushViewController(PhotoGridViewController(), animated: true)
//            let _vc = PopupController<UINavigationController>()
//            _vc.content.roundCorners()
//            _vc.content.setViewControllers([ProfileViewController()], animated: false)
//            self?.present(_vc, animated: true, completion: nil)
        }
        
        let s2 = CollectionSection(items: [photos])
        s2.headerItem = CollectionHeaderFooterView<CollectionHeader>(item: "custom section", kind: UICollectionView.elementKindSectionHeader)
        s2.insetForSection = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        director += s2
        
        let s3 = CollectionSection(items: [photos])
        s3.headerItem = CollectionHeaderFooterView<CollectionHeader>(item: "custom layout", kind: UICollectionView.elementKindSectionHeader)
        s3.insetForSection = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        director += s3
        
        director.performUpdates()
    }
}
