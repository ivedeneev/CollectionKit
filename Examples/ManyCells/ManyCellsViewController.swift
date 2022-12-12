//
//  ViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 1/29/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

class ManyCellsViewController: CollectionViewController {

    var section1: CollectionSection!
    var imageSection: CollectionSection!
    var section2: CollectionSection!
    
    let pokerCombos = ["High card", "Pair", "Two pairs", "Three of a kind", "Straight", "Flush", "Full house", "Four of a kind", "Straight-flush", "Royal flush"]
    
    let images: [UIImage] = [UIImage(named: "hazard"), UIImage(named: "jorghinho"), UIImage(named: "kovacic"), UIImage(named: "mount")].compactMap { $0 }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.alwaysBounceVertical = true
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffle)),
            UIBarButtonItem(title: "Mult. updates",style: .plain, target: self, action: #selector(crazyUpdate))
        ]
        
        let itemsForSection1 = pokerCombos.prefix(5).map { CollectionItem<TextCell>(item: $0).adjustsWidth(true) }
        section1 = CollectionSection(items: itemsForSection1)
        section1.headerItem = CollectionHeaderFooterView<CollectionHeader>(item: "Poker combos")
        director += section1
        
        imageSection = CollectionSection(items: images.map(CollectionItem<ImageCell>.init))
        imageSection.insetForSection = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        imageSection.lineSpacing = 2
        imageSection.minimumInterItemSpacing = 2
        director += imageSection

        director.performUpdates()
    }
    
    @objc func shuffle() {
        imageSection.items.shuffle()
        director.performUpdates()
    }
    
    @objc func crazyUpdate() {
        section1.items.removeLast()
        section1 += CollectionItem<TextCell>(item: Date().description)
        
        let sectionToInsert = CollectionSection(items: [CollectionItem<TextCell>(item: "INSERTED AT \(Date().description)")])
        director.insert(section: sectionToInsert, at: 0)
        
        section1.insert(item: CollectionItem<TextCell>(item: "insert 1").adjustsWidth(true), at: 1)
        section1.items.remove(at: 2)
        imageSection.items.shuffle()
        director.performUpdates()
    }
}

