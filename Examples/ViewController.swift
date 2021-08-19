//
//  ViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 6/24/21.
//

import UIKit
import AGInputControls

class ViewController: UIViewController {
    @IBOutlet weak var field_1: OTPCodeTextField!
    @IBOutlet weak var field_2: OTPCodeTextField!
    @IBOutlet weak var phoneField: PhoneTextField!
    @IBOutlet weak var floatTextField: FloatingLabelTextField!
    
    @IBOutlet weak var floatingFieldNoFormatting: FloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        field_1.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        field_1.decoration = .rect
        
        field_2.borderStyle = .none
        field_2.backgroundColor = .white
        field_2.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        field_2.decorationColor = UIColor.systemBlue.withAlphaComponent(0.1)
        field_2.decoration = .rect
        field_2.letterSpacing = 24
        field_2.length = 4
        field_2.font = UIFont(name: "Avenir", size: 30)?.monospaced
        
        phoneField.backgroundColor = .systemBackground
        phoneField.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        phoneField.phoneMask = "+X (XXX) XXX-XX-XX"
        phoneField.backgroundColor = UIColor.systemPink.withAlphaComponent(0.1)
        
        floatTextField.placeholder = "Card number"
        floatTextField.tintColor = .systemPink
        floatTextField.backgroundColor = .white
        floatTextField.formattingMask = "XXXX XXXX XXXX XXXX"
        floatTextField.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        floatTextField.minimumFontSize = 36
        floatTextField.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        floatTextField.highlightsWhenActive = true
        
        field_1.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        field_2.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        floatTextField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
    }
    
    @objc private func didChangeEditing(textField: UITextField) {
//        print(type(of: textField), textField.text)
    }
}


class MyTextField: FormattingTextField {
    override func formattedText(text: String?) -> String? {
        return text?.uppercased()
    }
}
