//
//  PhoneTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 6/25/21.
//

import UIKit

/// Textfield for phone wormatting. `showsMask` works correctly only with Russian phones
open class PhoneTextField: FormattingTextField {
    
    open override var formattingMask: String? {
        didSet {
            guard let formattingMask = formattingMask else {
                return
            }

            formatter = PhoneNumberFormatter(mask: formattingMask)
        }
    }
    
    open override var textAlignment: NSTextAlignment {
        get {
            super.textAlignment
        }
        
        set {
            /// `.center` just doesnt make sense from UX perspective if mask is enabled. We would expect to gradually replace placeholder with text which doesnt work with center alignment
            guard formattingMask != nil && newValue == .center else {
                super.textAlignment = newValue
                return
            }
            
            super.textAlignment = .left //TODO: check RTL languages
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
    }
    
    override func assertForExampleMasksAndPrefix() {
        guard let mask = exampleMask, !mask.isEmpty, let formattingMask = formattingMask, formatter != nil else { return }
        
        // It is common for phone fields to have _ 
        let fixedMask = mask.replacingOccurrences(of: "_", with: "0")
        
        assert(fixedMask == formattedText(text: fixedMask) && fixedMask.count == formattingMask.count, "Formatting mask and example mask should be in same format. This is your responsibility as a developer\nExampleMask: \(mask)\nFormatting mask: \(formattingMask)")
        assert(prefix.first(where: { $0.isLetter || $0.isNumber }) == nil || hasConstantPrefix, "You cannot have 'semi constant' prefixes at this point ")
    }
}
