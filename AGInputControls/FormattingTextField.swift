//
//  FormattingTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 8/16/21.
//

import UIKit

open class FormattingTextField: UITextField {
    /// Formatting mask. Example: `+X (XXX) XXX-XX-XX` where X is any digit.If mask is not specified textfield acts like normal UITextField. Default is nil
    open var formattingMask: String?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        registerTextListener()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        registerTextListener()
    }
    
    private func registerTextListener() {
        addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
    }
    
    @objc private func didChangeEditing() {
        guard let text = self.text else { return }
        self.text = formattedText(text: text)
    }
    
    open func formattedText(text: String?) -> String? {
        guard let mask = formattingMask, let t = text else { return text }

        let textRemovingAllButDigits = t.digitsOnly()

        var result = ""
        var index = textRemovingAllButDigits.startIndex
        for ch in mask where index < textRemovingAllButDigits.endIndex {
            if ch == "X" {
                result.append(textRemovingAllButDigits[index])
                index = textRemovingAllButDigits.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

//open override var text: String? {
//    set {
//        if let newValue = newValue {
//            super.text = formattedText(text: newValue)
//        } else {
//            super.text = newValue
//        }
//        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
//    }
//    get {
//        return super.text
//    }
//}

//public extension UITextField {
//    func registerFormattingMask(mask: String) {
//        NotificationCenter.default.addObserver(
//            forName: UITextField.textDidChangeNotification,
//            object: self,
//            queue: .main) { [weak self] n in
//                guard let self = self, let textField = n.object as? UITextField, textField === self else { return }
//                self.text = self._formattedText(text: self.text, mask: mask)
//            }
//    }
//
//    func _formattedText(text: String?, mask: String) -> String? {
//        guard let t = text else { return text }
//
//        let textRemovingAllButDigits = t.digitsOnly()
//
//        var result = ""
//        var index = textRemovingAllButDigits.startIndex
//        for ch in mask where index < textRemovingAllButDigits.endIndex {
//            if ch == "X" {
//                result.append(textRemovingAllButDigits[index])
//                index = textRemovingAllButDigits.index(after: index)
//            } else {
//                result.append(ch)
//            }
//        }
//        return result
//    }
//}
//
//
//@propertyWrapper
//public struct FormattingTextField_<T: UITextField> {
//
//    private let mask: String
//
//    public var wrappedValue: T {
//        didSet {
////            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
//        }
//    }
//
//    public init(wrappedValue: T, mask: String) {
//        self.mask = mask
//        self.wrappedValue = wrappedValue
//
//        NotificationCenter.default.addObserver(
//            forName: UITextField.textDidChangeNotification,
//            object: wrappedValue,
//            queue: .main) { n in
////            guard let textField = n.object as? UITextField, textField === self.wrappedValue else { return }
////                self.wrappedValue.text = self._formattedText(text: self.wrappedValue.text, mask: mask)
//            }
//    }
//
//    func _formattedText(text: String?, mask: String) -> String? {
//        guard let t = text else { return text }
//
//        let textRemovingAllButDigits = t.digitsOnly()
//
//        var result = ""
//        var index = textRemovingAllButDigits.startIndex
//        for ch in mask where index < textRemovingAllButDigits.endIndex {
//            if ch == "X" {
//                result.append(textRemovingAllButDigits[index])
//                index = textRemovingAllButDigits.index(after: index)
//            } else {
//                result.append(ch)
//            }
//        }
//        return result
//    }
//}
