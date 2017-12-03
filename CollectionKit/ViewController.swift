//
//  ViewController.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import SafariServices
import CollectionKit

class ViewController: UIViewController {
    var collectionView: UICollectionView!
    var director: CollectionDirector!
    var section: CollectionSection!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        collectionView.alwaysBounceVertical = true
        director = CollectionDirector(colletionView: collectionView)
        director.shouldUseAutomaticCellRegistration = true
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Header.reuseIdentifier)
//        collectionView.registerClass(CollectionCell.self)
//        collectionView.registerNib(CellFromXIB.self)
        section = CollectionSection()
        section.minimumInterItemSpacing = 0.5
//        section.insetForSection = UIEdgeInsetsMake(20, 0, 20, 0)
        section.lineSpacing = 2
        section.headerItem = CollectionItem<Header>(item: "title")
        for _ in 0..<3 {
            let row = CollectionItem<CollectionCell>(item: "text")
                .onSelect({ (_) in
                    print("i was tapped!")
                })
                .onDisplay({ (_,_) in
                    print("i was displayed")
                })
            section += row
        }
        
        director += section
    }
    
    @IBAction func addAction(_ sender: Any) {
        let  alertController = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Append item", style: .default, handler: { [unowned self] (_) in
            let row = CollectionItem<CollectionCell>(item: "hello")
            self.director.performUpdates { [unowned self] in
                self.section.append(item: row)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Insert at 0 position", style: .default, handler: { [unowned self] (_) in
            let row = CollectionItem<CellFromXIB>(item: "hello")
            
            self.director.performUpdates { [unowned self] in
                self.section.insert(item: row, at: 0)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Insert multiple items", style: .default, handler: { [unowned self] (_) in
            let row1 = CollectionItem<CellFromXIB>(item: "INSerteD Item [0]")
            let row2 = CollectionItem<CollectionCell>(item: "INSerteD Item [2]")
            
            self.director.performUpdates { [unowned self] in
                self.section.insert(items: [row1,row2], at: [0, 2])
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Reload item at 0 position", style: .default, handler: { [unowned self] (_) in
            guard let item = self.section.items.first as? CollectionItem<CollectionCell> else { return }
            self.director.performUpdates {
                item.reload(item: "reloaded item")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Append section", style: .default, handler: { [unowned self] (_) in
            let section = CollectionSection()
            section.minimumInterItemSpacing = 2
            section.insetForSection = UIEdgeInsetsMake(20, 20, 20, 20)
            section.lineSpacing = 1
            for _ in 0..<4 {
                let row = CollectionItem<CollectionCell>(item: "Inserted Section".uppercased())
                    .onSelect({ (_) in
                        print("i was tapped!")
                    })
                    .onDisplay({ (_,_) in
                        print("i was displayed")
                    })
                section += row
            }
            
            self.director.performUpdates { [unowned self] in
                self.director += section
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Remove item at 0 index", style: .destructive, handler: { [unowned self] (_) in
            self.director.performUpdates { [unowned self] in
                self.section.remove(at: 0)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Remove 1st item", style: .destructive, handler: { [unowned self] (_) in
            guard let item = self.section.items.first as? CollectionItem<CollectionCell> else { return }
            self.director.performUpdates { [unowned self] in
                self.section.remove(item: item)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Remove items at 0 and 2 positions", style: .destructive, handler: { [unowned self] (_) in
            self.director.performUpdates { [unowned self] in
                self.section.remove(at: [0,2])
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Remove last section", style: .destructive, handler: { [unowned self] (_) in
            self.director.performUpdates { [unowned self] in
                self.director.remove(section: self.director.sections.last!)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

