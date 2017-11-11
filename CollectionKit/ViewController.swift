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
//            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = .lightGray
        collectionView.alwaysBounceVertical = true
        director = CollectionDirector(colletionView: collectionView)
        collectionView.registerClass(CollectionCell.self)
        section = CollectionSection()
        section.minimumInterItemSpacing = 2
        section.insetForSection = UIEdgeInsetsMake(0, 20, 0, 20)
        section.lineSpacing = 2
        for _ in 0..<3 {
            let row = CollectionItem<CollectionCell>(item: "text")
                .onSelect({ (_) in
                    print("i was tapped!")
                }).onDisplay({ (_) in
                    print("i was displayed")
                })
            section += row
        }
        
        director += section
        
    
        let layer = CALayer()
        layer.backgroundColor = UIColor.red.cgColor
        layer.frame = self.view.bounds
        
//        let mask = CAShapeLayer()
//        mask.path = UIBezierPath(rect: mask.bounds).cgPath
//        mask.frame = self.view.bounds
//        mask.backgroundColor = UIColor.blue.cgColor
//        layer.mask = mask
//        mask.contents = mask
//        layer.masksToBounds = true
        view.layer.addSublayer(layer)

        let path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: 100, height: 100), cornerRadius: 0)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        print("dsad".capitalized)
    }
    
    
    @IBAction func action(_ sender: Any) {
//        director.sections.first?.items.remove(at: 0)
//        director.sections.first?.reload()
        (section.items.first as! CollectionItem<CollectionCell>).reload(item: "reloaded item")
    }
    
    @IBAction func addAction(_ sender: Any) {
        let row = CollectionItem<CollectionCell>(item: "hello")
//        section.insert(item: row, at: 0)
        section.append(item: row)
    }
    
    @IBAction func removeAction(_ sender: Any) {
        section.remove(at: 0)
    }
}

