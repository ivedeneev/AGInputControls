//
//  PhoneTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 6/25/21.
//

import UIKit

public protocol PhoneTextFieldFormattingDelegate: AnyObject {
    func formatPhoneNumber(for tf: PhoneTextField) -> String
}

/// Textfield for phone wormatting. `showsMask` works correctly only with Russian phones
open class PhoneTextField: FormattingTextField {
    
    weak var formattingDelegate: PhoneTextFieldFormattingDelegate?
    
    /// Phone format string were X is digit placeholder. Default is `+X (XXX) XXX-XX-XX`
    open var phoneMask: String = "+X (XXX) XXX-XX-XX"
    
    /// Shows example phone number with random digits applying selected phone mask
    open var showsMask = false
    
    private var prefix: String {
        phoneMask.components(separatedBy: " ").first ?? ""
    }
    
    open override var intrinsicContentSize: CGSize {
        let font_ = font ?? UIFont.systemFont(ofSize: 17)
        let height = font_.lineHeight
        let width = sizeOfText(phoneMask).width
        
        let caretWidth: CGFloat = 4 // assuming we dont have HUGE font. This should be fixed (e.g call caretRect method...)
        
        return CGSize(width: width + caretWidth, height: height)
    }
    
    open override var font: UIFont? {
        didSet {
            minimumFontSize = font?.pointSize ?? 20
            invalidateIntrinsicContentSize()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        if #available(iOS 10.0, *) {
            textContentType = .telephoneNumber
        }
        keyboardType = .phonePad
        borderStyle = .none
    }

    open override func formattedText(text: String?) -> String? {
        if let delegate = formattingDelegate {
            return delegate.formatPhoneNumber(for: self)
        }
        
        guard var t = text?.trimmingCharacters(in: .whitespacesAndNewlines), t != "+" else { return "" }
        
        let prefix = showsMask ? prefix : "+7"
        switch t.first {
        case "8":
            t = prefix + t.dropFirst()
        case "9":
            t = prefix + t
        case "7":
            t = showsMask ? prefix + t : "+" + t
        case "+":
            break
        default:
            t = prefix + t
        }

        if t.count > 1, t.first != "+" || String(Array(t)[1]) != "7" && t.first == "+" {
            t.insert(contentsOf: prefix, at: .init(utf16Offset: 0, in: t))
        }
        
        if showsMask {
            setNeedsDisplay()
        }
        
        return t.formattedNumber(mask: phoneMask)
    }
    
    open override func caretRect(for position: UITextPosition) -> CGRect {
        guard showsMask else {
            return super.caretRect(for: position)
        }
        
        var rect = super.caretRect(for: position)
        if text?.isEmpty ?? true {
            rect.origin.x += sizeOfText(prefix).width
            return rect
        }
        return rect
    }
    
    private lazy var attributedMask = NSMutableAttributedString(string: phoneMask, attributes: [
        .font : font,
        .foregroundColor : UIColor.lightGray
    ])
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard showsMask else { return }
        let text = self.text ?? ""
        
        let phoneMask = "+7 (912) 876-45-67"
        let phone = text + phoneMask.suffix(phoneMask.count - text.count)
        let textToDraw = NSMutableAttributedString(string: phone, attributes: [
            .font : font,
            .foregroundColor : UIColor.lightGray
        ])
        
        textToDraw.addAttributes([.foregroundColor : textColor], range: .init(location: 0, length: 2))
        
        textToDraw.draw(in: textRect(forBounds: bounds))
    }
    
    private func sizeOfText(_ text: String) -> CGSize {
        return (text as NSString).boundingRect(
            with: UIScreen.main.bounds.size,
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font : font],
            context: nil).size
    }
}

extension String {
    func formattedNumber(mask: String) -> String {
        let rawPhone = digitsOnly()

        var result = ""
        var index = rawPhone.startIndex
        for ch in mask where index < rawPhone.endIndex {
            if ch == "X" || "0123456789".contains(ch) {
                result.append(rawPhone[index])
                index = rawPhone.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func digitsOnly() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}
