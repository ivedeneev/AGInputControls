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
        didSet { invalidateIntrinsicContentSize() }
    }
    
    /// Current limitation: prefix either contains only digits or only X and +. Otherways behaviour is unspecified
    internal override var prefix: String {
        guard let separator = phoneMask.first(
            where: { !($0.isNumber || $0.isLetter || $0 == "+") }
        ) else {
            return ""
        }
        
        return phoneMask.components(separatedBy: String(separator)).first ?? ""
    }
    
    /// If prefix is fixed user doesnt need to type it.
    private var highlightPrefix: Bool { hasConstantPrefix }
    
    open override var intrinsicContentSize: CGSize {
        let font_ = font ?? UIFont.systemFont(ofSize: 17)
        let height = font_.lineHeight
        let width = sizeOfText(phoneMask.replacingOccurrences(of: "X", with: "0")).width
        
        let caretWidth: CGFloat = caretRect(for: endOfDocument).width
        
        return CGSize(width: width + caretWidth, height: height)
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
        if !last.isNumber {
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
            
            // +7 case is handled above
            if highlightPrefix && !t.hasPrefix(prefix) && prefix != "+7" {
                t = prefix + t
            }
        }
        
        let formatted = t.formattedNumber(mask: phoneMask)
        
        return formatted
    }
    
    open override func deleteBackward() {
        guard let range = selectedTextRange else {
            super.deleteBackward()
            return
        }
        
        let cursorPosition = offset(from: beginningOfDocument, to: range.start)
        
        if cursorPosition <= prefix.count && hasConstantPrefix {
            setCursorPosition(offset: prefix.count)
            return
        }
        
        super.deleteBackward()
    }
}
