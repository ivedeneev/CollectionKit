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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: SectionBackgroundFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.alwaysBounceVertical = true
        director = CollectionDirector(colletionView: collectionView)
        
        configureDirector()
        
        director.reload()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(performReload))
    }
    
    func configureDirector() {
        director.removeAll()
        
        section1.removeAll()
        section1.items.append(contentsOf: array1.map { CollectionItem<CellFromXIB>(item: $0) })
        section1.lineSpacing = 2
        section1.minimumInterItemSpacing = 1
//        if !section1.isEmpty {
//            director += section1
//        }
        
        section1.insetForSection = UIEdgeInsetsMake(30, 25, 0, 25)
        
        section2.removeAll()
        section2.items.append(contentsOf: array2.map { CollectionItem<CellFromXIB>(item: $0) })
        section2.lineSpacing = 2
        section2.minimumInterItemSpacing = 1
        if !section2.isEmpty {
            director += section2
        }
        
        section2.insetForSection = UIEdgeInsetsMake(30, 25, 0, 25)
        
//        section3.items.append(contentsOf: array3.map { CollectionItem<CellFromXIB>(item: $0) })
//        section3.lineSpacing = 2
//        section3.minimumInterItemSpacing = 1
//        section3.insetForSection = UIEdgeInsetsMake(30, 25, 0, 25)
//
//        if !section3.isEmpty {
//            director += section3
//        }
    }
    
    @objc func performReload() {
//        guard let item1 = self.array2.first, let item2 = self.array2.last else { return }
//        self.array1.append(contentsOf: [item1, item2])
//        self.array2.removeLast()
//        self.array2.removeFirst()
//
//        self.section1.removeAll()
//        self.section1.items.append(contentsOf: self.array1.map { CollectionItem<CellFromXIB>(item: $0) })
//
//        self.section2.removeAll()
//        self.section2.items.append(contentsOf: self.array2.map { CollectionItem<CellFromXIB>(item: $0) })
//
//
//        if self.director.contains(section: self.section3) {
//            self.director.remove(section: self.section3)
//        } else {
//            //                self.director += self.section3
//            //            self.director.remove(section: self.section1)
//            self.director.insert(section: self.section3, at: 0)
//        }
//
//        director.testUpdate(updates: { [unowned self] in
//
//        }, completion: nil)
        
//        array1.append(array2.first!)
//        array2.remove(at: 0)
        array2.append("blackburn")
        configureDirector()
        director.performUpdates()
    }
}
