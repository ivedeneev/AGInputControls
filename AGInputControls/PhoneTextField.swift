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

open class PhoneTextField: FormattingTextField {
    
    weak var formattingDelegate: PhoneTextFieldFormattingDelegate?
    
    /// Phone format string were X is digit placeholder. Default is `+X (XXX) XXX-XX-XX`
    open var phoneMask: String = "+X (XXX) XXX-XX-XX"
    
    open override var intrinsicContentSize: CGSize {
        let font_ = font ?? UIFont.systemFont(ofSize: 17)
        let height = font_.lineHeight
        let width = (phoneMask as NSString).boundingRect(
            with: UIScreen.main.bounds.size,
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [.font : font_],
            context: nil).width
        
        let caretWidth: CGFloat = 4 // assuming we dont have HUGE font. This should be fixed
        
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
        
        switch t.first {
        case "8":
            t = "+7" + t.dropFirst()
        case "9":
            t = "+7" + t
        default:
            break
        }
        
        if t.count > 1, t.first != "+" || String(Array(t)[1]) != "7" && t.first == "+" {
            t.insert(contentsOf: "+7", at: .init(utf16Offset: 0, in: t))
        }
        
        return t.formattedNumber(mask: phoneMask)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds
    }
    
//    open override func caretRect(for position: UITextPosition) -> CGRect {
//        return super.caretRect(for: position)
//    }
}

extension String {
    func formattedNumber(mask: String) -> String {
        let rawPhone = digitsOnly()

        var result = ""
        var index = rawPhone.startIndex
        for ch in mask where index < rawPhone.endIndex {
            if ch == "X" {
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
    
    // +3197010281448
//    +38-068-906-15-16 UA
    // +375 25 762-59-14 BEL
//    func test(prefix: String, mask: String) -> String {
//
//    }

//    var isValidPhone: Bool {
//        return digitsOnly().count == 11
//    }
}
