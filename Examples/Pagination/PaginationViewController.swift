//
//  PaginationViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 25.11.2023.
//  Copyright © 2023 Igor Vedeneev. All rights reserved.
//

import UIKit
import IVCollectionKit

final class PaginationViewController: CollectionViewController {
    var posts = [String]()
    let postsSection = CollectionSection()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pagination"
        
        director.delegate = self
        postsSection.insetForSection = UIEdgeInsets(top: 0, left: 8, bottom: 16, right: 8)
        postsSection.lineSpacing = 8
        director += postsSection
        
        appendPosts()
        configure()
    }
    
    func appendPosts() {
        let limit = 20
        let newPosts = (posts.count..<posts.count+limit).map {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return "\($0)\n" + String((0..<300).map { _ in letters.randomElement()! })
          }
        
        posts.append(contentsOf: newPosts)
    }
    
    func configure() {
        postsSection.removeAll()
        postsSection += posts.map { post in
                let vm = MultilineTextViewModel(text: post)
                return CollectionItem<MultilineTextCell>(item: vm)
                    .onSelect { [vm, director] _ in
                        vm.isExpanded = !vm.isExpanded
                        director.performUpdates()
                    }
            }
        
        if isLoading {
            postsSection += CollectionItem<PaginationLoadingCell>(item: Void()).adjustsWidth(true)
        }
        
        director.performUpdates()
    }
}

extension PaginationViewController: CollectionDirectorDelegate {
    func didScrollToBottom(director: CollectionDirector) {
        print(#function)
        guard !isLoading else { return }
        print("DID SCROLL TO BOTTOM")
        isLoading = true
        configure()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.appendPosts()
            self.isLoading = false
            self.configure()
        }
    }
}
