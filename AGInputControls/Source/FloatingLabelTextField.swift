//
//  FloatingLabelTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 26/08/2018.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import UIKit

open class FloatingLabelTextField : FormattingTextField {
    
    enum HighlightStyle {
        case none
        case color(UIColor?, Bool)
    }
    
    private let underlineView = UIView()
    private let placeholderLabel = UILabel()
    
    /// Text paddings. Default is zero
    open var padding: UIEdgeInsets = .zero
    
    /// Bottom label. Typically used for errors
    public let bottomLabel = UILabel()
    
    ///
    open var bottomText: String? {
        didSet {
            bottomLabel.text = bottomText
            bottomLabel.sizeToFit()
        }
    }
    
    /// Color of placeholder label and underline view. Default is `UIColor.lightGray`
    open override var placeholderColor: UIColor {
        didSet {
            configurePlaceholderColor()
        }
    }
    
    /// Show or hide underline view. Default is `true`
    open var showUnderlineView = true {
        didSet {
            underlineView.isHidden = !showUnderlineView
        }
    }
    
    /// Colors placeholder label and underline view in tint color. Default is `false`
    open var highlightsWhenActive = false
    
    open override var placeholder: String? {
        didSet {
            configurePlaceholder()
        }
    }
    
    open override var font: UIFont? {
        didSet {
            configurePlaceholder()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        //TODO: do smth with height calculatuion
        let height: CGFloat
        let lineHeight = font!.lineHeight * 2.25
        let paddings: CGFloat = padding.top + padding.bottom
        height = lineHeight + paddings
        let bottomHeight: CGFloat = hasBottomText ? bottomLabelHeight : 0
        
        return CGSize(width: UIScreen.main.bounds.width * 0.6, height: height + bottomHeight)
    }
    
    
    private var hasBottomText: Bool {
        bottomText.isEmptyOrTrue
    }
    
    private var bottomLabelHeight: CGFloat {
        bottomLabel.font.lineHeight.rounded(.up)
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
        addSubview(underlineView)
        borderStyle = .none
        clearButtonMode = .always
        addSubview(placeholderLabel)
        
        addSubview(bottomLabel)
        bottomLabel.font = font?.withSize(font!.pointSize * 0.75)
        bottomLabel.textColor = placeholderColor
        
        setPlaceholderBottomAttributes()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureFont()
        configurePlaceholder()
        configurePlaceholderColor()
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
        placeholderLabel.frame.origin.x = padding.left
        placeholderLabel.frame.origin.y = padding.top
        placeholderLabel.frame.size.height = editingRect(forBounds: bounds).height * 0.5
        
        guard isFirstResponder, highlightsWhenActive else { return }
        placeholderLabel.textColor = tintColor
    }
    
    private func setPlaceholderBottomAttributes() {
        placeholderLabel.transform = .identity
        placeholderLabel.frame = editingRect(forBounds: bounds)
        placeholderLabel.textColor = UIColor.lightGray
    }
    
    private func configureFont() {
        placeholderLabel.font = font
        minimumFontSize = font?.pointSize ?? 17
        placeholderLabel.sizeToFit()
    }
    
    private func configurePlaceholder() {
        guard placeholder != nil else { return }
        placeholderLabel.text = placeholder
        placeholderLabel.sizeToFit()
    }
    
    private func configurePlaceholderColor() {
        placeholderLabel.textColor = placeholderColor
        underlineView.backgroundColor = placeholderColor
    }
    
    open override func formattedText(text: String?) -> String? {
        let text = super.formattedText(text: text)
        if let txt = text, !txt.isEmpty {
            if placeholderLabel.transform == .identity {
                animatePlaceholderLabelOnTop()
            }
        } else {
            animatePlaceholderLabelOnBottom()
        }
        
        return text
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var p = padding
        p.top += font!.lineHeight * 0.45 // FIXME: magic numbers
        p.right = bounds.width - super.editingRect(forBounds: bounds).width
        p.bottom += hasBottomText ? bottomLabelHeight : 0
        return bounds.inset(by: p)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        .zero
    }
    
    open override func drawExampleMask(rect: CGRect) {
        // currently its unsupported. Not sure if its really needed. 
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var p = padding
        p.top += font!.lineHeight * 0.45 // FIXME: magic numbers
        p.right = bounds.width - super.editingRect(forBounds: bounds).width
        p.bottom += hasBottomText ? bottomLabelHeight : 0
        return bounds.inset(by: p)
    }
    
    //TODO:
//    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        //FIXME: get rid of '-4' magic number
        rect.origin.y -= hasBottomText ? bottomLabelHeight / 2 - 4 : -4
        return rect
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if (text ?? "").isEmpty {
            setPlaceholderBottomAttributes()
        } else {
            setPlaceholderTopAttributes()
        }
        
        let bottomLabelSize = bottomLabel.frame.size
        let underlineHeight: CGFloat = 1

        let underlineBottomPadding: CGFloat = hasBottomText ? bottomLabelHeight + underlineHeight : underlineHeight

        underlineView.frame = CGRect(
            x: padding.left,
            y: bounds.height - underlineBottomPadding - padding.bottom,
            width: bounds.width - padding.left - padding.right,
            height: underlineHeight
        )
        
        bottomLabel.frame = CGRect(
            x: padding.left,
            y: underlineView.frame.maxY,
            width: min(bottomLabelSize.width, bounds.width - (padding.left + padding.right)),
            height: bottomLabelSize.height
        )
    }
    
    open override func becomeFirstResponder() -> Bool {
        if highlightsWhenActive {
            underlineView.backgroundColor = tintColor
        }
        return super.becomeFirstResponder()
    }

    open override func resignFirstResponder() -> Bool {
        placeholderLabel.textColor = placeholderColor
        underlineView.backgroundColor = placeholderColor
        return super.resignFirstResponder()
    }
}
