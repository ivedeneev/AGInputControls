//
//  PaddingTextField.swift
//  AGInputControls
//
//  Created by Igor Vedeneev on 05/03/2024.
//

import UIKit

open class PaddingTextField: UITextField {
    /// Paddings for text area and floating placeholder. Default is (8, 8, 8, 8)
    open var textPadding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: textPadding)
    }
}
