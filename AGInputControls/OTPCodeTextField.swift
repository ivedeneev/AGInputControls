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
            defaultTextAttributes.updateValue(letterSpacing, forKey: .kern)
            invalidateIntrinsicContentSize()
        }
    }
    
    /// Height of underline dash
    @IBInspectable open var dashHeight: CGFloat = 3
    
    /// Used for placeholder and bottom dashes. Default is `UIColor.gray`
    @IBInspectable open var placeholderColor: UIColor = UIColor.lightGray
    
    /// Used for background rects under digits`
    @IBInspectable open var decorationColor: UIColor = UIColor(white: 0.9, alpha: 1)
    
    /// Decorate every symbol: underline dash, rounded rect or none. If dash or rect selected using monospaced font is highly recommended
    open var decoration: Decoration = .none
    
    open override var font: UIFont? {
        didSet {
            symbolWidth = _oneSymbolWidth()
            minimumFontSize = font!.pointSize
            invalidateIntrinsicContentSize()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    private func setup() {
        addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        defaultTextAttributes.updateValue(letterSpacing, forKey: .kern)
        tintColor = .clear
        keyboardType = .numberPad
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(placeholderColor.cgColor)
        context.setFillColor(decorationColor.cgColor)
        
        switch decoration {
        case .dash:
            context.setLineWidth(dashHeight)
            context.move(to: CGPoint(x: 0, y: bounds.height))
            context.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            context.setLineDash(phase: 0, lengths: [symbolWidth - letterSpacing, letterSpacing])
            context.strokePath()
        case .rect:
            let width: CGFloat = symbolWidth - letterSpacing + digitPadding * 2
            let originX = textOrigin().x
            let xWithPadding = decoration == .rect ? originX - digitPadding : originX
            for i in 0..<length {
                let x = max(CGFloat(i) * (symbolWidth), 0)
                let rect = CGRect(x: x + xWithPadding, y: 0, width: width, height: rect.height)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: 4).cgPath
                context.addPath(path)
            }
            
            context.fillPath()
        default:
            break
        }
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
        .zero
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
        guard let text = text, text.count > length else { oldText = self.text!; return }
        self.text = text.replacingOccurrences(of: oldText, with: "")
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
