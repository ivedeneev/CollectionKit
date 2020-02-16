//
//  PhotoGridViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/16/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit
import Photos

final class PhotoGridViewController: CollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let results = PHAsset.fetchAssets(with: options)
        let section = PhotoGridSection(results: results)
        director += section
        director.reload()
        collectionView.contentInsetAdjustmentBehavior = .always
    }
}
