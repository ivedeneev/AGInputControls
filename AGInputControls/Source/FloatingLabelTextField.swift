//
//  FloatingLabelTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 26/08/2018.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import UIKit

open class FloatingLabelTextField : FormattingTextField {

    //MARK: - Public variables
    /// Space between text and floating placeholder
    open var floatingLabelBottomPadding: CGFloat = 4

    /// Space between  underline view and bottom label
    open var bottomTextTopPadding: CGFloat = 8
    
    /// Spacing between text and right and left views
    open var rightLeftViewsTextSpacing: CGFloat = 8
    
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
    
    /// Accent color for error state. Border, underline view and placeholder and bottom labels are affected. Default is red
    open var errorTintColor: UIColor = .red
    
    /// Indicates, is textfield is in error state or not.
    open var isError: Bool = false {
        didSet {
            if isError {
                if nonErrorTintColor == nil {
                    nonErrorTintColor = tintColor
                }

                tintColor = errorTintColor
            } else {
                guard nonErrorTintColor != nil else { return }
                tintColor = nonErrorTintColor
            }
            configureColors()
        }
    }
    
    ///
    open var borderWidth: CGFloat = 0 {
        didSet {
            guard borderWidth > 0 else { return }
            setNeedsDisplay()
        }
    }
    
    /// Corner radius for text area
    open var cornerRadius: CGFloat = 0 {
        didSet {
            guard cornerRadius > 0 else { return }
            setNeedsDisplay()
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
    
    /// Colors placeholder label, bottom label and underline view in `tintColor` when textfield is focused. Default is `true`
    open var highlightsWhenActive = true
    
    //MARK: - Variables overrides
    /// Color of placeholder label, bottom label and underline view for inactive state
    open override var placeholderColor: UIColor {
        didSet { configureColors() }
    }
    
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
    
    /// Background color is set only for text and floating placeholder area. Bottom text area always has default background color
    open override var backgroundColor: UIColor? {
        get { privateBackgroundColor }
        set { privateBackgroundColor = newValue }
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
    
    //MARK: - Private variables
    private var hasBottomText: Bool {
        !bottomText.isEmptyOrTrue
    }
    
    private var bottomLabelHeight: CGFloat {
        bottomLabel.font.lineHeight.rounded(.up)
    }
    
    private var privateBackgroundColor: UIColor? {
        didSet { setNeedsDisplay() }
    }
    
    private var nonErrorTintColor: UIColor?
    
    private let underlineView = UIView()
    private let placeholderLabel = UILabel()
    
    private let floatingLabelScaleFactor: CGFloat = 0.75
    
    private var textYOrigin: CGFloat {
        textPadding.top + (font!.lineHeight * floatingLabelScaleFactor + floatingLabelBottomPadding)
    }
    
    //MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    //MARK: - Setup
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
    
    //MARK: - Private
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
        placeholderLabel.frame.origin.x = textEditingRect(for: bounds).minX
        placeholderLabel.frame.origin.y = textPadding.top
    }
    
    private func setPlaceholderBottomAttributes() {
        let lineHeight = font!.lineHeight
        let textAreaHeight = textYOrigin + lineHeight + textPadding.bottom
        placeholderLabel.transform = .identity
        var rect = textEditingRect(for: bounds)
        rect.origin.y = (textAreaHeight - lineHeight) / 2
        placeholderLabel.frame = rect
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
    
    private func configureColors() {
        defer {
            setNeedsDisplay()
        }
        
        var color: UIColor?
        
        if isError {
            color = errorTintColor
        } else if isFirstResponder && highlightsWhenActive {
            color = tintColor
        } else {
            color = placeholderColor
        }
        
        placeholderLabel.textColor = color
        underlineView.backgroundColor = color
        bottomLabel.textColor = color
    }
    
    private func leftRightViewsYOrigin(viewHeight: CGFloat) -> CGFloat {
        textPadding.top + (textYOrigin + font!.lineHeight - textPadding.top - viewHeight) / 2
    }
    
    private func textEditingRect(for bounds: CGRect) -> CGRect {
        var p = textPadding
        p.top = textYOrigin
        p.right = bounds.width - super.editingRect(forBounds: bounds).width
        let hasBottomText = !(bottomText ?? "").isEmpty
        p.bottom += hasBottomText ? bottomLabelHeight + bottomTextTopPadding : 0
        
        if let leftView, leftViewMode != .never {
            p.left += leftView.frame.width + rightLeftViewsTextSpacing
        }
        
        let result = bounds.inset(by: p)
        
        return result
    }
    
    //MARK: - Overrides
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
        
        if borderWidth > 0 {
            var borderRect = rect
            borderRect.size.height = textYOrigin + font!.lineHeight + textPadding.bottom
            borderRect = borderRect.insetBy(dx: borderWidth, dy: borderWidth)
            
            assert(cornerRadius >= 0, "cornerRadius should be greater or equal zero")
            assert(borderWidth >= 0, "borderWidth should be greater or equal zero")
            let path = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius)
            
            var color: UIColor?
            if isError {
                color = errorTintColor
            } else {
                color = isFirstResponder && highlightsWhenActive ? tintColor : placeholderColor
            }
            
            color?.setStroke()
            context.addPath(path.cgPath)
            context.strokePath()
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureFont()
        configurePlaceholder()
        configureColors()
    }

    // we should hide original placehoder in favor of floating placeholder
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        .zero
    }
    
    open override func drawExampleMask(rect: CGRect) {
        // currently its unsupported. Not sure if its really needed. 
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textEditingRect(for: bounds)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        textEditingRect(for: bounds)
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += textPadding.left
        rect.origin.y = leftRightViewsYOrigin(viewHeight: rect.height)
        return rect
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= textPadding.right
        rect.origin.y = leftRightViewsYOrigin(viewHeight: rect.height)
        return rect
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = leftRightViewsYOrigin(viewHeight: rect.height)
        return rect
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if !isFirstResponder && text.isEmptyOrTrue {
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
        let value = super.becomeFirstResponder()
        
        if value {
            animatePlaceholderLabelOnTop()
            configureColors()
        }
        
        return value
    }

    open override func resignFirstResponder() -> Bool {
        
        let value = super.resignFirstResponder()
        
        if value {
            configureColors()
            
            if text.isEmptyOrTrue {
                animatePlaceholderLabelOnBottom()
            }
        }
        
        return value
    }
}
