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
    @IBOutlet weak var fixedWidthPhoneField: PhoneTextField!
    @IBOutlet weak var floatingFieldNoFormatting: FloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        field_1.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        field_1.decoration = .dash
        field_1.showsCaret = true
        
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
        floatTextField.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        floatTextField.highlightsWhenActive = true
        floatTextField.bottomText = "Incorrect card format"
        floatTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        floatTextField.clipsToBounds = true
        floatTextField.layer.cornerRadius = 8
        
        fixedWidthPhoneField.font = UIFont(name: "Avenir", size: 30)//?.monospaced
        fixedWidthPhoneField.showsMask = true
        fixedWidthPhoneField.phoneMask =  "+7 (XXX) XXX-XX-XX"
        
        field_1.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        field_2.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)

        floatTextField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        
        floatingFieldNoFormatting.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        floatingFieldNoFormatting.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    @objc private func didChangeEditing(textField: UITextField) {
//        print(type(of: textField), textField.text)
        guard let tf = textField as? FloatingLabelTextField else { return }
        tf.bottomText = tf.text!.count % 2 == 0 ? "Incorrect card format" : nil
    }
}


class MyTextField: FormattingTextField {
    override func formattedText(text: String?) -> String? {
        return text?.uppercased()
    }
}
