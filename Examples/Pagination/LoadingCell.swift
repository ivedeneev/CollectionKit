//
//  LoadingCell.swift
//  Examples
//
//  Created by Igor Vedeneev on 25.11.2023.
//  Copyright © 2023 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

class PaginationLoadingCell: UICollectionViewCell {
    
    private let activityIndicatior = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        
        activityIndicatior.hidesWhenStopped = true
        contentView.addSubview(activityIndicatior)
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatior.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaginationLoadingCell: ConfigurableCollectionItem {
    
    func configure(item: Void) {
        activityIndicatior.startAnimating()
    }
    
    static func estimatedSize(
        item: Void,
        boundingSize: CGSize,
        in section: AbstractCollectionSection
    ) -> CGSize {
        let width = boundingSize.width
        return CGSize(width: width, height: 50)
    }
}
