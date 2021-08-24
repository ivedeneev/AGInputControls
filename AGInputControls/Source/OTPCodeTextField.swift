//
//  OTPCodeTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 6/24/21.
//

import UIKit

/// `UITextField` subclass to handle OTP code input. Each digit is underlined.
/// Aside from default properties you can customize code length, letter spacing,
///  underline dash height and placeholder color are configurable
/// **WARNING: using monospaced font is highly recommended**
@IBDesignable open class OTPCodeTextField: UITextField {
    
    /// Code length. Usually it 4-6 symbols. Default is 4
    @IBInspectable open var length: Int = 4
    
    /// Letter spacing between digits. Default is 24
    @IBInspectable open var letterSpacing: CGFloat = 24 {
        didSet {
            guard letterSpacing != oldValue else { return }
            configureLetterSpacing()
        }
    }
    
    /// Height of underline dash
    @IBInspectable open var dashHeight: CGFloat = 3
    
    /// Used for placeholder and bottom dashes. Default is `UIColor.gray`
    @IBInspectable open var placeholderColor: UIColor = UIColor.lightGray
    
    /// Used for background rects under digits`
    @IBInspectable open var decorationColor: UIColor = UIColor(white: 0.9, alpha: 1)
    
    /// Show or hide caret
    @IBInspectable open var showsCaret: Bool = false
    
    /// Decorate every symbol: underline dash, rounded rect or none. If dash or rect selected using monospaced font is highly recommended
    open var decoration: Decoration = .none
    
    open override var font: UIFont? {
        didSet {
            configureFont()
        }
    }
    
    private var _placeholder: String {
        String(repeating: "0", count: length)
    }
    
    private var digitPadding: CGFloat {
        letterSpacing * 0.3
    }
    
    private var symbolWidth: CGFloat!
    private var oldText = ""
    private var caretWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureLetterSpacing()
        configureFont()
        oldText = text ??  ""
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        print(action)
        let disabledSelectors: Set<Selector> = [
            #selector(UIResponderStandardEditActions.paste(_:)),
            #selector(UIResponderStandardEditActions.copy(_:)),
            #selector(UIResponderStandardEditActions.cut(_:)),
            #selector(UIResponderStandardEditActions.select(_:)),
            #selector(UIResponderStandardEditActions.selectAll(_:)),
        ]
        
        if disabledSelectors.contains(action) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    private func setup() {
        addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        defaultTextAttributes.updateValue(letterSpacing, forKey: .kern)
        keyboardType = .numberPad
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
        
        gestureRecognizers?.forEach { gr in
            guard gr is UILongPressGestureRecognizer else { return }
            gr.isEnabled = false
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), decoration != .none else { return }
        
        context.setStrokeColor(placeholderColor.cgColor)
        context.setFillColor(decorationColor.cgColor)
        context.setLineWidth(dashHeight)
        let originX = textOrigin().x
        
        let width: CGFloat = symbolWidth - letterSpacing + digitPadding * 2
        let xWithPadding = decoration == .rect ? originX - digitPadding : originX - digitPadding + width * 0.1
        for i in 0..<length {
            let x = max(CGFloat(i) * (symbolWidth), 0)
            switch decoration {
            case .dash:
                let rect = CGRect(x: x + xWithPadding, y: rect.height - dashHeight, width: width * 0.8, height: dashHeight)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: dashHeight / 2).cgPath
                context.addPath(path)
            case .rect:
                let rect = CGRect(x: x + xWithPadding, y: 0, width: width, height: rect.height)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: 4).cgPath
                context.addPath(path)
            default:
                break
            }
        }

        context.fillPath()
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            origin: textOrigin(),
            size: CGSize(width: contentWidth() + letterSpacing + symbolWidth, height: bounds.height)
        )
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            origin: textOrigin(),
            size: CGSize(width: contentWidth() + letterSpacing, height: bounds.height)
        )
    }
    
    // TODO: Placeholders ignored at this point. In future maybe we will add custom placeholders like zeros, dots or asterisks if needed.
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        .zero
    }
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        let caretRect = super.caretRect(for: position)
        caretWidth = caretRect.width
        return showsCaret ? caretRect : .zero
    }
    
    open override var intrinsicContentSize: CGSize {
        let attrstr = NSAttributedString(
            string: _placeholder,
            attributes: [
                .font : font!,
                .kern: letterSpacing
            ])
                
        var size = attrstr.boundingRect(
            with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            context: nil
        ).size
        
        size.width -= letterSpacing
        
        switch decoration {
        case .rect:
            size.width += digitPadding * 2
            size.height += digitPadding
        default:
            break
        }
        _cachedIntrinsicContentSize = size
        
        return size
    }
    
    var _cachedIntrinsicContentSize: CGSize = .zero
    
    private func _oneSymbolWidth() -> CGFloat {
        let attrstr = NSAttributedString(
            string: "0",
            attributes: [
                .font : font!,
                .kern: letterSpacing
            ])
                
        let size = attrstr.boundingRect(
            with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            context: nil
        ).size
        
        return size.width
    }
    
    private func textOrigin() -> CGPoint {
        let _contentWidth = _cachedIntrinsicContentSize.width
        var x = max((bounds.width - _contentWidth) / 2, 0)
        if decoration == .rect {
            x += digitPadding
        }
        return CGPoint(x: x, y: 0)
    }
    
    private func contentWidth() -> CGFloat {
        symbolWidth * CGFloat(length) + letterSpacing * (CGFloat(length) - 1)
    }
    
    @objc private func didChangeEditing() {
//        print("[\(text ?? "empty")]", "[\(oldText)]")
        guard let txt = text, txt.count > length else {
            oldText = text!; return
        }
        
        self.text = txt.replacingOccurrences(of: oldText, with: "")
    }
    
    private func configureLetterSpacing() {
        defaultTextAttributes.updateValue(letterSpacing, forKey: .kern)
        invalidateIntrinsicContentSize()
    }
    
    private func configureFont() {
        symbolWidth = _oneSymbolWidth()
        minimumFontSize = font!.pointSize
        invalidateIntrinsicContentSize()
    }
}

public extension OTPCodeTextField {
    /// Type of highlighting every digit. Available styles: dash, rounded rect or none. If dash or rect selected using monospaced font is highly recommended
    enum Decoration {
        
        /// no additinal graphics
        case none
        
        /// Each digit is underlined with dash
        case dash
        
        /// Each digit has rounded rectangle under it
        case rect
    }
}
