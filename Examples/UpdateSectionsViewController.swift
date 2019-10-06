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
    
//    var array1 = ["privet", "kak", "dela", "ska"]
    var array1 = [String]()
    var array2 = ["cska", "real", "juventus", "chelsea"]
    var array3 = ["facebook", "instargam", "pinterest", "linkedin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.alwaysBounceVertical = true
        director = CollectionDirector(colletionView: collectionView)
        
        configureDirector()
        director.reload()
//         director.performUpdates()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(performReload))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func configureDirector() {
        director.removeAll()
        
        director += section(with: array2, id: "futbol")
        director += section(with: array3, id: "siliconwalley")
        director += section(with: ["5ka", "perek", "next", "domru"], id: "agima")
    }
    
    @objc func performReload() {
//        configureDirector()
//
        director.sections.first?.append(item: CollectionItem<CellFromXIB>(item: "inserted").adjustsWidth(true))
        director.sections[1].append(item: CollectionItem<CellFromXIB>(item: "inserted").adjustsWidth(true))
//
//        let s1 = CollectionSection(id: "s1")
//        s1 += CollectionItem<CellFromXIB>(item: "test1").adjustsWidth(true)
//        s1 += CollectionItem<CellFromXIB>(item: "test2").adjustsWidth(true)
//        s1.insetForSection = UIEdgeInsetsMake(25, 0, 0, 0)
//
//        let s2 = CollectionSection(id: "s2")
//        s2 += CollectionItem<CellFromXIB>(item: "s2_1").adjustsWidth(true)
//        s2 += CollectionItem<CellFromXIB>(item: "s2_2").adjustsWidth(true)
//        s2.insetForSection = UIEdgeInsetsMake(25, 0, 0, 0)
//
//        director.append(sections: [s1, s2])
        director.removeSection(at: 0)
        
        director.performUpdates()
    }
    
    func section(with array: [String], id: String) -> AbstractCollectionSection {
        let s1 = CollectionSection(id: id)
        s1.lineSpacing = 2
        s1.minimumInterItemSpacing = 1
        s1 += array.map { CollectionItem<CellFromXIB>(item: $0).adjustsWidth(true) }
        s1.insetForSection = UIEdgeInsets(top: 25, left: 8, bottom: 0, right: 8)
        return s1
    }
}
