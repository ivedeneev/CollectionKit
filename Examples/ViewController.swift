//
//  ViewController.swift
//  CollectionKit
//
//  Created by Igor Vedeneev on 13.09.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
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
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: SectionBackgroundFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        collectionView.alwaysBounceVertical = true
        director = CollectionDirector(colletionView: collectionView)
//        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Header.reuseIdentifier)
//        collectionView.registerClass(CollectionCell.self)
//        collectionView.registerNib(CellFromXIB.self)
        section = CollectionSection()
        section.minimumInterItemSpacing = 0.5
        section.lineSpacing = 2
        let vm = HeaderViewModel()
        vm.title = "Показать все"
        let header = CollectionHeaderFooterView<Header>(item: vm, kind: UICollectionElementKindSectionHeader)
        section.headerItem = header
        
        let texts1 = ["Акция", "для", "дибилов"]
        texts1.forEach {
            let row = CollectionItem<CollectionCell>(item: $0)
            row.adjustsWidth = true
            section += row
        }
        
        director += section
        
        let s2 = CollectionSection()
        s2.insetForSection = UIEdgeInsetsMake(30, 0, 0, 0)
        let texts2 = ["Пятерочка", "дифф", "алло"]
        texts2.forEach {
            let row = CollectionItem<CollectionCell>(item: $0)
            row.adjustsWidth = true
            s2 += row
        }
        
        director += s2
        
        director.reload()
    }
    
    @IBAction func addAction(_ sender: Any) {
        let  alertController = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Reorder", style: .default, handler: { [unowned self] (_) in
            let texts1 = ["Акция", "для", "дибилов", "Пятерочка"]
            self.section.removeAll()
            texts1.forEach {
                let row = CollectionItem<CollectionCell>(item: $0)
                row.adjustsWidth = true
                self.section += row
            }
            
            self.director.sections.last?.removeAll()
            let texts2 = ["test", "дифф", "алло", "konec"]
            texts2.forEach {
                let row = CollectionItem<CollectionCell>(item: $0)
                row.adjustsWidth = true
                let sec = self.director.sections.last!
                (sec as! CollectionSection) += row
            }

            self.director.testUpdate()
        }))
        
//        alertController.addAction(UIAlertAction(title: "Append item to 1st section", style: .default, handler: { [unowned self] (_) in
//            let row = CollectionItem<CollectionCell>(item: "hello")
//            row.adjustsWidth = true
//            self.director.sections.first?.append(item: row)
//            self.director.testUpdate(completion: {
//                print("sosat")
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Insert at 0 position", style: .default, handler: { [unowned self] (_) in
//            let row = CollectionItem<CellFromXIB>(item: "hello")
//
//            self.director.performUpdates(updates:  { [unowned self] in
//                self.section.insert(item: row, at: 0)
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Insert multiple items", style: .default, handler: { [unowned self] (_) in
//            let row1 = CollectionItem<CellFromXIB>(item: "INSerteD Item [0]")
//            let row2 = CollectionItem<CollectionCell>(item: "INSerteD Item [2]")
//
//            self.director.performUpdates (updates: { [unowned self] in
//                self.section.insert(items: [row1,row2], at: [0, 2])
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Reload item at 0 position", style: .default, handler: { [unowned self] (_) in
//            guard let item = self.section.items.first as? CollectionItem<CollectionCell> else { return }
//            self.director.performUpdates(updates:  {
//                item.reload(item: "reloaded item")
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Append section", style: .default, handler: { [unowned self] (_) in
//            let section = CollectionSection()
//            section.minimumInterItemSpacing = 2
//            section.insetForSection = UIEdgeInsetsMake(20, 20, 20, 20)
//            section.lineSpacing = 1
//
//            for _ in 0..<4 {
//                let row = CollectionItem<CollectionCell>(item: "Inserted Section".uppercased())
//                    .onSelect({ (_) in
//                        print("i was tapped!")
//                    })
//                    .onDisplay({ (_,_) in
//                        print("i was displayed")
//                    })
//                row.adjustsWidth = true
//                section += row
//            }
//            self.director.performUpdates(updates:  { [unowned self] in
//                self.director += section
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Append 2 sections", style: .default, handler: { [unowned self] (_) in
//            let section1 = CollectionSection()
//            section1.minimumInterItemSpacing = 2
//            section1.insetForSection = UIEdgeInsetsMake(20, 20, 20, 20)
//            section1.lineSpacing = 1
//
//            for _ in 0..<2 {
//                let row = CollectionItem<CollectionCell>(item: "1111111111".uppercased())
//                section1 += row
//                row.adjustsWidth = true
//            }
//
//            let section2 = CollectionSection()
//            section2.minimumInterItemSpacing = 2
//            section2.insetForSection = UIEdgeInsetsMake(20, 50, 20, 50)
//            section2.lineSpacing = 10
//            for _ in 0..<2 {
//                let row = CollectionItem<CollectionCell>(item: "2222222".uppercased())
//                section2 += row
//                row.adjustsWidth = true
//            }
//
//            self.director.performUpdates(updates:  { [unowned self] in
//                self.director += [section1, section2]
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Remove item at 0 index", style: .destructive, handler: { [unowned self] (_) in
//            self.director.performUpdates(updates:  { [unowned self] in
//                self.section.remove(at: 0)
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Remove 1st item", style: .destructive, handler: { [unowned self] (_) in
//            guard let item = self.section.items.first as? CollectionItem<CollectionCell> else { return }
//            self.director.performUpdates(updates:  { [unowned self] in
//                self.section.remove(item: item)
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Remove items at 0 and 2 positions", style: .destructive, handler: { [unowned self] (_) in
//            self.director.performUpdates(updates:  { [unowned self] in
//                self.section.remove(at: [0,2])
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Remove last section", style: .destructive, handler: { [unowned self] (_) in
//            self.director.performUpdates(updates: {  [unowned self] in
//                self.director.remove(section: self.director.sections.last!)
//            })
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Remove header", style: .destructive, handler: { [unowned self] (_) in
//            self.section.headerItem = nil
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                self.director.setNeedsUpdate()
//            })
//        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}

