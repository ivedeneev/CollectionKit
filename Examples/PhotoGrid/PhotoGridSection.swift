//
//  PhotoGridSection.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/16/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit
import Photos

final class PhotoGridSection: AbstractCollectionSection {
    
    var identifier: String {
        return "PhotoGridSection"
    }
    
    var headerItem: AbstractCollectionHeaderFooterItem?
    
    var footerItem: AbstractCollectionHeaderFooterItem?
    
    var insetForSection: UIEdgeInsets = .zero
    
    var minimumInterItemSpacing: CGFloat = 2
    
    var lineSpacing: CGFloat = 2
    
    private var results: PHFetchResult<PHAsset>
    
    init(results: PHFetchResult<PHAsset>) {
        self.results = results
    }
    
    func numberOfItems() -> Int {
        return results.count
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
    }
    
    func sizeForItem(at indexPath: IndexPath, boundingSize: CGSize) -> CGSize {
        return PhotoCell.estimatedSize(item: results[indexPath.row], boundingSize: boundingSize, in: self)
    }
    
    func currentItemIds() -> [String] {
        return []
    }
    
    func cell(for director: CollectionDirector, indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PhotoCell = director.dequeueReusableCell(indexPath: indexPath)
        cell.configure(item: results[indexPath.row])
        return cell
    }
}
