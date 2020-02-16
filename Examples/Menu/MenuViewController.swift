//
//  MenuViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/16/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class MenuViewController: CollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cells = CollectionItem<TextCell>(item: "Multiple cells").onSelect { [weak self] (_) in
            self?.navigationController?.pushViewController(ViewController(), animated: true)
        }
        
        let photos = CollectionItem<TextCell>(item: "Custom Section (photo grid)").onSelect { [weak self] (_) in
            self?.navigationController?.pushViewController(PhotoGridViewController(), animated: true)
        }
        
        let section = CollectionSection(items: [cells, photos])
        director += section
        director.performUpdates()
    }
}
