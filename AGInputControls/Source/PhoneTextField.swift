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
    open var phoneMask: String = "+# (###) ###-##-##" {
        didSet { formattingMask = phoneMask }
    }
    
    /// Current limitation: prefix either contains only digits or only X and +. Otherways behaviour is unspecified
    internal override var prefix: String {
        guard let separator = phoneMask.first(
            where: { !($0.isNumber || $0 == "+" || $0 == "#") }
        ) else {
            return ""
        }
        
        return phoneMask.components(separatedBy: String(separator)).first ?? ""
    }
    
    open override var intrinsicContentSize: CGSize {
        let font_ = font ?? UIFont.systemFont(ofSize: 17)
        let height = font_.lineHeight
        let width = sizeOfText(phoneMask.replacingOccurrences(of: "#", with: "0")).width
        
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

        guard var t = text?.trimmingCharacters(in: .whitespacesAndNewlines), t != "+" else { return "" }

        if showsMask {
            setNeedsDisplay()

            if hasConstantPrefix && !t.hasPrefix(prefix) {
                t = prefix + t
            }
        }
        
        if let delegate = formattingDelegate {
            return delegate.formatPhoneNumber(for: self)
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
        // dont let set cursor position in prefix. only after
        if cursorPosition <= prefix.count && hasConstantPrefix {
            setCursorPosition(offset: prefix.count)
            return
        }

        super.deleteBackward()
    }
}
