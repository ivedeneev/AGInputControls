//
//  FloatingLabelTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 26/08/2018.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import UIKit

open class FloatingLabelTextField : FormattingTextField {
    
    private var placeholderFont: UIFont! {
        didSet {
            placeholderLabel.font = placeholderFont
            invalidateIntrinsicContentSize()
        }
    }
    
    private let underlineLayer = CALayer()
    private var placeholderLabel = UILabel()
    var flotatingLabelTopPosition: CGFloat = 0
    var showUnderlineView = true
    open lazy var padding: UIEdgeInsets = UIEdgeInsets(
        top: font!.lineHeight / 2,
        left: 0,
        bottom: font!.lineHeight / 2,
        right: 0
    )
    
    open override var placeholder: String? {
        didSet {
            guard placeholder != nil else { return }
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    open override var font: UIFont? {
        didSet {
            placeholderFont = font!
            placeholderLabel.sizeToFit()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        //TODO: do smth with height calculatuion and deal with minimum font scale
        let height: CGFloat
        let lineHeight = font!.leading + abs(font!.descender) + font!.ascender + font!.capHeight
        let paddings: CGFloat = 0//padding.top + padding.bottom
        height = lineHeight + paddings + lineHeight * 0.75
        
        return CGSize(width: UIScreen.main.bounds.width * 0.6, height: height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.addSublayer(underlineLayer)
        underlineLayer.backgroundColor = UIColor.lightGray.cgColor
        borderStyle = .none
        backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        
        placeholderLabel.textColor = UIColor.lightGray
        addSubview(placeholderLabel)
        clearButtonMode = .always
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
        let top: CGFloat = 0
        placeholderLabel.frame.origin.y = top
    }
    
    private func setPlaceholderBottomAttributes() {
        placeholderLabel.transform = .identity
        placeholderLabel.frame = textRect(forBounds: bounds)
    }
    
    open override func formattedText(text: String?) -> String? {
        if let txt = text, !txt.isEmpty {
            if self.placeholderLabel.frame.origin.y != flotatingLabelTopPosition {
                animatePlaceholderLabelOnTop()
            }
        } else {
            animatePlaceholderLabelOnBottom()
        }
        
        return super.formattedText(text: text)
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var p = padding
        p.top += font!.lineHeight * 0.4
        p.bottom += font!.lineHeight * 0.1
        p.right += bounds.width - super.textRect(forBounds: bounds).width
        return bounds.inset(by: p)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        .zero
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var p = padding
        p.top += font!.lineHeight * 0.4
        p.bottom = font!.lineHeight * 0.1
        p.right = bounds.width - super.editingRect(forBounds: bounds).width
        return bounds.inset(by: p)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if (text ?? "").isEmpty {
            setPlaceholderBottomAttributes()
        } else {
            setPlaceholderTopAttributes()
        }
    }
}
