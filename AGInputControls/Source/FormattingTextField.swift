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
