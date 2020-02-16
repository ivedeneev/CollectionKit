//
//  PhotoCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 2/16/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit
import Photos
import Combine

final class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()
    var cancellable: Cancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cancellable?.cancel()
        cancellable = nil
    }
}

extension PhotoCell: ConfigurableCollectionItem {
    func configure(item: PHAsset) {
        cancellable = PHImageManager.default().image(asset: item).assign(to: \.image, on: imageView)
    }
    
    static func estimatedSize(item: PHAsset?, boundingSize: CGSize) -> CGSize {
        let side = min(boundingSize.width, boundingSize.height)
        let cellSide = ((side - 2 * 2) / 3).rounded(.down)
        return CGSize(width: cellSide, height: cellSide)
    }
}

extension PHImageManager {
    func image(asset: PHAsset) -> AnyPublisher<UIImage?, Never> {
        var requestId: PHImageRequestID!
        return Future<UIImage?, Never> { (promise) in
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.isNetworkAccessAllowed = true
            options.resizeMode = .none
            options.isSynchronous = false
            requestId = self.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { (img, userInfo) in
                promise(.success(img))
            }
        }
        .handleEvents(receiveCancel: { self.cancelImageRequest(requestId) })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
