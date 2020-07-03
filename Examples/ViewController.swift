//
//  ViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 1/29/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

class ViewController: CollectionViewController {

    var section1: CollectionSection!
    var imageSection: CollectionSection!
    var section2: CollectionSection!
    
    let pokerCombos = ["High card", "Pair", "Two pairs", "Three of a kind", "Straight", "Flush", "Full house", "Four of a kind", "Straight-flush", "Royal flush"]
    
    let images: [UIImage] = [UIImage(named: "hazard"), UIImage(named: "jorghinho"), UIImage(named: "kovacic"), UIImage(named: "mount")].compactMap { $0 }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.alwaysBounceVertical = true
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(shuffle)), UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(crazyUpdate))
        ]
        
        let itemsForSection1 = pokerCombos.prefix(5).map { CollectionItem<TextCell>(item: $0).adjustsWidth(true) }
        section1 = CollectionSection(items: itemsForSection1)
        section1.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        director += section1
        
//        imageSection = CollectionSection(id: "images")
        imageSection = CollectionSection(items: images.map(CollectionItem<ImageCell>.init))
        imageSection.insetForSection = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        imageSection.lineSpacing = 2
        imageSection.minimumInterItemSpacing = 2
        director += imageSection
//
//        let itemsForSection2 =  pokerCombos.suffix(5).map(CollectionItem<TextCell>.init)
//        section2 = CollectionSection(items: itemsForSection2)
//        section2.lineSpacing = 2
//        section2.insetForSection = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        director += section2

        director.performUpdates()
    }
    
    @objc func shuffle() {
        imageSection.items.shuffle()
        
        section1.items.removeLast()
        section1 += CollectionItem<TextCell>(item: Date().description)
        
        let sectionToInsert = CollectionSection(items: [CollectionItem<TextCell>(item: "INS  \(Date().description)")])
        director.insert(section: sectionToInsert, at: 0)
        director.performUpdates()
    }
    
    @objc func crazyUpdate() {
//        imageSection.items.shuffle()
//        director.sections.remove(at: 0)
        
//        director.remove(section: section1)
        imageSection.items.shuffle()
//        imageSection += images.map(CollectionItem<ImageCell>.init)
//        director += imageSection
        
//        imageSection +=
        
        director.performUpdates(in: imageSection)
    }
}

