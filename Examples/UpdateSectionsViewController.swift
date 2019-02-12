//
//  UpdateSectionsViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/11/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

final class UpdateSectionsViewController : UIViewController {
    var collectionView: UICollectionView!
    var director: CollectionDirector!
    
    let section1 = CollectionSection()
    let section2 = CollectionSection()
    let section3 = CollectionSection()
    
    var array1 = ["privet", "kak", "dela", "ska"]
    var array2 = ["cska", "real", "juventus", "chelsea"]
    var array3 = ["facebook", "instargam", "pinterest", "linkedin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: SectionBackgroundFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.alwaysBounceVertical = true
        director = CollectionDirector(colletionView: collectionView)
        
        section1.items.append(contentsOf: array1.map { CollectionItem<CellFromXIB>(item: $0) })
        section1.lineSpacing = 2
        section1.minimumInterItemSpacing = 1
        director += section1
        section1.insetForSection = UIEdgeInsetsMake(30, 25, 0, 25)
        
        section2.items.append(contentsOf: array2.map { CollectionItem<CellFromXIB>(item: $0) })
        section2.lineSpacing = 2
        section2.minimumInterItemSpacing = 1
        director += section2
        section2.insetForSection = UIEdgeInsetsMake(30, 25, 0, 25)
        
        section3.items.append(contentsOf: array3.map { CollectionItem<CellFromXIB>(item: $0) })
        section3.lineSpacing = 2
        section3.minimumInterItemSpacing = 1
        section3.insetForSection = UIEdgeInsetsMake(30, 25, 0, 25)
        
        director.reload()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(performReload))
    }
    
    @objc func performReload() {
        guard let item1 = array2.first, let item2 = array2.last else { return }
        array1.append(contentsOf: [item1, item2])
        array2.removeLast()
        array2.removeFirst()
        
        section1.removeAll()
        section1.items.append(contentsOf: array1.map { CollectionItem<CellFromXIB>(item: $0) })
        
//        print("old: ", section2.numberOfItems())
        section2.removeAll()
        section2.items.append(contentsOf: array2.map { CollectionItem<CellFromXIB>(item: $0) })
//        print("new: ", section2.numberOfItems())
        
        
        if director.contains(section: section3) {
            director.remove(section: section1)
        } else {
//            director += section3
//            director.remove(section: section1)
            director.insert(section: section3, at: 0)
        }
        
        director.testUpdate()
    }
}
