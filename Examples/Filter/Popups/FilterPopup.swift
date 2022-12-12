//
//  FilterPopup.swift
//  Examples
//
//  Created by Igor Vedeneev on 3/22/20.
//  Copyright © 2020 Igor Vedeneev. All rights reserved.
//

import UIKit

protocol FilterPopup {
    func setupHeaderView(title: String)
    func setupToolbar()
    func cancel()
    func reset()
}


extension FilterPopup where Self: UIViewController {
    func setupHeaderView(title: String) {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        view.addSubview(headerView)
        
        let titleLabel = UILabel()
        let cancelButton = UIButton()
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = title
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = .secondarySystemBackground
        cancelButton.addTarget(self, action: "cancel", for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cancelButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16),
            cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 18),
            cancelButton.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -10)
        ])
    }
    
    func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemPurple
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isTranslucent = false
        view.addSubview(toolbar)

        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        toolbar.setItems([
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: "reset"),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "cancel"),
        ], animated: false)
    }
}
