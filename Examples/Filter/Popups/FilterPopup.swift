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
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let titleLabel = UILabel()
        let cancelButton = UIButton()
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = title
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        cancelButton.backgroundColor = .secondarySystemBackground
        cancelButton.addTarget(self, action: "cancel", for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -10).isActive = true
    }
    
    func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.tintColor = .systemPurple
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isTranslucent = false
        view.addSubview(toolbar)
        
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34).isActive = true
        
        toolbar.setItems([
            UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: "reset"),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "cancel"),
        ], animated: false)
    }
}
