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
    
    private let floatingLabelScaleFactor: CGFloat = 0.75
    
    /// Space between text and floating placeholder
    open var floatingLabelBottomPadding: CGFloat = 4
    
    private var textYOrigin: CGFloat {
        textPadding.top + (font!.lineHeight * floatingLabelScaleFactor + floatingLabelBottomPadding)
    }

    /// Space between text and underline view and bottom label
    open var bottomTextTopPadding: CGFloat = 8
    
    /// Paddings for text area and floating placeholder. Default is (8, 8, 8, 8)
    open var textPadding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    /// Bottom label. Typically used for errors
    public let bottomLabel = UILabel()
    
    /// Bottom text for errors or promts
    open var bottomText: String? {
        get { bottomLabel.text }
        set {
            if bottomText.isEmptyOrTrue != newValue.isEmptyOrTrue {
                setNeedsDisplay()
            }
            bottomLabel.text = newValue
        }
    }
    
    open override var backgroundColor: UIColor? {
        get { privateBackgroundColor }
        set { privateBackgroundColor = newValue }
    }
    
    
    ///
    open var borderColor: UIColor? {
        didSet {
            guard borderColor != nil else { return }
            setNeedsDisplay()
        }
    }
    
    
    ///
    open var borderWidth: CGFloat = 0 {
        didSet {
            guard borderWidth > 0 else { return }
            setNeedsDisplay()
        }
    }
    
    ///
    open var cornerRadius: CGFloat = 0 {
        didSet {
            guard cornerRadius > 0 else { return }
            setNeedsDisplay()
        }
    }
    
    private var privateBackgroundColor: UIColor? {
        didSet { setNeedsDisplay() }
    }
    
    /// Color of placeholder label and underline view. Default is `UIColor.lightGray`
    open override var placeholderColor: UIColor {
        didSet {
            configurePlaceholderColor()
        }
    }
    
    
    /// Height of underline view
    open var underlineHeight: CGFloat = 1 {
        didSet { invalidateIntrinsicContentSize() }
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
        var height: CGFloat
        let lineHeight = font!.lineHeight
        let paddings: CGFloat = textPadding.top + textPadding.bottom
        let topLabelHeight = lineHeight * floatingLabelScaleFactor
        height = lineHeight + paddings + 1 + topLabelHeight + floatingLabelBottomPadding
        let bottomHeight: CGFloat = hasBottomText ? bottomLabelHeight + bottomTextTopPadding : 0
        return CGSize(width: UIScreen.main.bounds.width * 0.6, height: height + bottomHeight)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        if let bgColor = privateBackgroundColor {
            var bgRect = rect
            bgRect.size.height = textYOrigin + font!.lineHeight + textPadding.bottom
            assert(cornerRadius >= 0, "corner radius should be greater or equal zero")
            let path = UIBezierPath(roundedRect: bgRect, cornerRadius: cornerRadius)
            bgColor.setFill()
            context.addPath(path.cgPath)
            context.fillPath()
        }
        
        if let borderColor, borderWidth > 0 {
            var borderRect = rect
            borderRect.size.height = textYOrigin + font!.lineHeight + textPadding.bottom
            borderRect = borderRect.insetBy(dx: borderWidth, dy: borderWidth)
            
            assert(cornerRadius >= 0, "cornerRadius should be greater or equal zero")
            assert(borderWidth >= 0, "borderWidth should be greater or equal zero")
            let path = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
            borderColor.setStroke()
            context.addPath(path.cgPath)
            context.strokePath()
        }
    }
    
    private var hasBottomText: Bool {
        !bottomText.isEmptyOrTrue
    }
    
    private var bottomLabelHeight: CGFloat {
        bottomLabel.font.lineHeight.rounded(.up)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    private func initialSetup() {
        addSubview(underlineView)
        borderStyle = .none
        clearButtonMode = .always
        addSubview(placeholderLabel)
        
        addSubview(bottomLabel)
        bottomLabel.font = font?.withSize(font!.pointSize * floatingLabelScaleFactor)
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
        placeholderLabel.transform = CGAffineTransform(
            scaleX: floatingLabelScaleFactor,
            y: floatingLabelScaleFactor
        )
        placeholderLabel.frame.origin.x = textPadding.left
        placeholderLabel.frame.origin.y = textPadding.top
        
        guard isFirstResponder, highlightsWhenActive else { return }
        placeholderLabel.textColor = tintColor
    }
    
    private func setPlaceholderBottomAttributes() {
        placeholderLabel.transform = .identity
        placeholderLabel.frame = editingRect(forBounds: bounds)
        placeholderLabel.textColor = placeholderColor
    }
    
    private func configureFont() {
        placeholderLabel.font = font
        minimumFontSize = font!.pointSize
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
        var p = textPadding
        p.top = textYOrigin
        p.right = bounds.width - super.editingRect(forBounds: bounds).width
        let hasBottomText = !(bottomText ?? "").isEmpty
        p.bottom += hasBottomText ? bottomLabelHeight + bottomTextTopPadding : 0
        return bounds.inset(by: p)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        .zero
    }
    
    open override func drawExampleMask(rect: CGRect) {
        // currently its unsupported. Not sure if its really needed. 
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var p = textPadding
        p.top = textYOrigin
        p.right = bounds.width - super.editingRect(forBounds: bounds).width
        let hasBottomText = !(bottomText ?? "").isEmpty
        p.bottom += hasBottomText ? bottomLabelHeight + bottomTextTopPadding : 0
        return bounds.inset(by: p)
    }
    
    //TODO:
//    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = textYOrigin
        
        return rect
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if (text ?? "").isEmpty {
            setPlaceholderBottomAttributes()
        } else {
            setPlaceholderTopAttributes()
        }

        underlineView.frame = CGRect(
            x: 0,
            y: textYOrigin + font!.lineHeight + textPadding.bottom,
            width: bounds.width,
            height: underlineHeight
        )
        
        bottomLabel.frame = CGRect(
            x: textPadding.left,
            y: underlineView.frame.maxY + bottomTextTopPadding,
            width: bottomLabel.text.isEmptyOrTrue ? 0 : bounds.width - (textPadding.left + textPadding.right),
            height: bottomLabel.font.lineHeight
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
