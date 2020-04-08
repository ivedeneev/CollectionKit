//
//  TextField.swift
//  jetfly
//
//  Created by Igor Vedeneev on 26/08/2018.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import UIKit

class FloatingLabelTextField : UITextField {
    
    var placeholderFont: UIFont?
    private let underlineLayer = CALayer()
    private var placeholderLabel = UILabel()
    var flotatingLabelTopPosition: CGFloat = -14
    var showUnderlineView = true
    
    var kg_placeholder: String? {
        didSet {
            guard kg_placeholder != nil else { return }
            placeholderLabel.text = kg_placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    init() {
        super.init(frame: .zero)
        initialSetup()
    }
    
    private func initialSetup() {
        placeholderFont = .systemFont(ofSize: 13)
        layer.addSublayer(underlineLayer)
        underlineLayer.backgroundColor = UIColor.separator.cgColor
        borderStyle = .none
        clipsToBounds = false
        
        placeholderLabel.textColor = UIColor.secondaryLabel
        addSubview(placeholderLabel)
        clearButtonMode = .always
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kg_textDidChange(notif:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    
    private func setupPlaceholderLabel() {
        placeholderLabel.frame = CGRect(origin: .zero, size: .zero)
    }
    
    private func animatePlaceholderLabelOnTop() {
        UIView.animate(withDuration: 0.2) {
            self.setPlaceholderTopAttributes()
        }
    }
    
    private func animatePlaceholderLabelOnBottom() {
        UIView.animate(withDuration: 0.2) {
            self.setPlaceholderBottomAttributes()
        }
    }
    
    private func setPlaceholderTopAttributes() {
        placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        placeholderLabel.frame.origin.x = 0
        let top: CGFloat = (bounds.height - placeholderLabel.font.lineHeight + padding.top) / 2 - font!.lineHeight * 0.75 - 4
        placeholderLabel.frame.origin.y = top
    }
    
    private func setPlaceholderBottomAttributes() {
        placeholderLabel.transform = .identity
        placeholderLabel.frame.origin.x = 0
        placeholderLabel.frame.origin.y = (bounds.height - placeholderLabel.font.lineHeight + padding.top) / 2
    }
    
    @objc private func kg_textDidChange(notif: Notification) {
        guard let textField = notif.object as? FloatingLabelTextField, textField == self else { return }
        
        if placeholderLabel.superview == nil {
            addSubview(placeholderLabel)
        }
        
        if let txt = text, !txt.isEmpty {
            if self.placeholderLabel.frame.origin.y != flotatingLabelTopPosition {
                animatePlaceholderLabelOnTop()
            }
        } else {
            animatePlaceholderLabelOnBottom()
        }
    }
    
    let padding = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if (text ?? "").isEmpty {
            setPlaceholderBottomAttributes()
        } else {
            setPlaceholderTopAttributes()
        }
    }
}
