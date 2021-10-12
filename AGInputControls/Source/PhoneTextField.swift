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
    
    /// Shows example phone number with random digits applying selected phone mask
    open var showsMask = false
    
    /// Color of placeholder. Default is `UIColor.lightGray`
    open var placeholderColor: UIColor = .lightGray
    
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
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard showsMask else { return }
        drawMask()
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard !showsMask else { return .zero }
        return super.placeholderRect(forBounds: bounds)
    }
    
    open override func deleteBackward() {
        guard let range = selectedTextRange, var txt = self.text, txt.count >= prefix.count, selectedTextRange?.start != endOfDocument else {
            super.deleteBackward()
            return
        }
        
        let cursorPosition = offset(from: beginningOfDocument, to: range.start)
        if !"0123456789".contains(txt.prefix(cursorPosition).last!) {
            txt.remove(at: .init(utf16Offset: cursorPosition - 1, in: txt))
            txt.remove(at: .init(utf16Offset: cursorPosition - 2, in: txt))
            setFormattedText(txt)
            setCursorPosition(offset: cursorPosition - 2)
            return
        }
        
        super.deleteBackward()
        setCursorPosition(offset: cursorPosition - 1)
    }
    
    open func setFormattedText(_ text: String) {
        self.text = formattedText(text: text)
    }
}

extension PhoneTextField {
    
    private func setCursorPosition(offset: Int) {
        guard let newPosition = position(from: beginningOfDocument, in: .right, offset: offset) else {return }
        selectedTextRange = textRange(from: newPosition, to: newPosition)
    }
    
    private func sizeOfText(_ text: String) -> CGSize {
        return (text as NSString).boundingRect(
            with: UIScreen.main.bounds.size,
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font : font],
            context: nil).size
    }
    
    private func drawMask() {
        let text = self.text ?? ""
        
        let phoneMask = phoneMask
            .replacingOccurrences(of: "XXX", with: "454")
            .replacingOccurrences(of: "XX", with: "45")
        
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
