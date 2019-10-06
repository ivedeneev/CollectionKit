//
//  ManualUpdateVC.swift
//  Examples
//
//  Created by Igor Vedeneev on 4/7/19.
//  Copyright © 2019 Igor Vedeneev. All rights reserved.
//

import CollectionKit
import UIKit

final class ManualUpdateVC : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var strings = [String]()
    var test = false
    
    lazy var director = CollectionDirector.init(colletionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.dataSource = self
//        collectionView.registerNib(CellFromXIB.self)
        collectionView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: 250, height: 50)
        director.reload()
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        strings.append("He11o")
        test = true
        
        let sec = CollectionSection(items: [CollectionItem<CellFromXIB>(item: "test").adjustsWidth(true)])
        director += sec
        director.performUpdates()
        
//        print(collectionView.numberOfSections)
//        collectionView.performBatchUpdates({
//            collectionView.insertSections([0])
//            collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
//        }) { (_) in
//            //
//        }
    }
}

extension ManualUpdateVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return test ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellFromXIB", for: indexPath) as! CellFromXIB
        cell.configure(item: strings[indexPath.row])
        return cell
    }
}
