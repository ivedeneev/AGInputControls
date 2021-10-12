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
    open var phoneMask: String = "+X (XXX) XXX-XX-XX" {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    private var prefix: String {
        phoneMask.components(separatedBy: " ").first ?? ""
    }
    
    open override var intrinsicContentSize: CGSize {
        let font_ = font ?? UIFont.systemFont(ofSize: 17)
        let height = font_.lineHeight
        let width = sizeOfText(phoneMask.replacingOccurrences(of: "X", with: "0")).width
        
        let caretWidth: CGFloat = caretRect(for: endOfDocument).width
        
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
    
    override func didChangeEditing() {
        var pos = currentPosition()
        let textCount = text!.count
        super.didChangeEditing()
        guard let last = text!.prefix(pos).last else { return }
        if !"0123456789".contains(last) {
            pos = pos + 1 // не 1, а количество элементов до первой цифры с конца
        }
        if pos < textCount, text!.count > prefix.count {
            setCursorPosition(offset: pos)
        }
    }

    open override func formattedText(text: String?) -> String? {
        
        if let delegate = formattingDelegate {
            return delegate.formatPhoneNumber(for: self)
        }
        
        guard var t = text?.trimmingCharacters(in: .whitespacesAndNewlines), t != "+" else { return "" }
        
        if prefix == "+7" {
            let prefix = showsMask ? prefix : "+7"
            switch t.first {
            case "8":
                if !showsMask {
                    t = prefix + t.dropFirst()
                } else {
                    t = t.count == phoneMask.filter { "0123456789X".contains($0) }.count ? prefix + t.dropFirst() : prefix + t
                }
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
        }
        
        if showsMask {
            setNeedsDisplay()
        }
        
        let formatted = t.formattedNumber(mask: phoneMask)
        
        return formatted
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
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard !showsMask else { return .zero }
        return super.placeholderRect(forBounds: bounds)
    }
    
    open override func drawExampleMask(rect: CGRect) {
        guard let phoneMask = exampleMask else { return }
        let text = self.text ?? ""
        
        let phone = text + phoneMask.suffix(phoneMask.count - text.count)
        let textToDraw = NSMutableAttributedString(string: phone, attributes: [
            .font : font,
            .foregroundColor : placeholderColor
        ])
        
        // highlight prefix
        textToDraw.addAttributes(
            [.foregroundColor : textColor],
            range: .init(location: 0, length: 2)
        )
        
        textToDraw.draw(at: CGPoint(x: 0, y: ((bounds.height - font!.lineHeight) / 2).rounded()))
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
