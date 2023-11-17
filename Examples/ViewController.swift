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
    
    @IBOutlet weak var lettersField: FormattingTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        field_1.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        field_1.decoration = .dash
        field_1.showsCaret = true
        field_1.decorationColor = .systemRed
        
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
        phoneField.formattingMask = "+# (###) ###-##-##"
        phoneField.exampleMask = "+7 (888) 777-66-55"
        phoneField.backgroundColor = UIColor.systemPink.withAlphaComponent(0.1)
        
        floatingFieldNoFormatting.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        floatingFieldNoFormatting.bottomText = "Test"
        floatingFieldNoFormatting.textPadding = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 8)
        floatingFieldNoFormatting.showUnderlineView = true
        floatingFieldNoFormatting.highlightsWhenActive = true
        floatingFieldNoFormatting.clearButtonMode = .never
        floatingFieldNoFormatting.rightViewMode = .whileEditing
        
        let customClearButton = UIButton()
        customClearButton.backgroundColor = .systemPurple
        customClearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        customClearButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        floatingFieldNoFormatting.rightView = customClearButton
        
        floatTextField.placeholder = "Card number"
        floatTextField.tintColor = .systemPurple
        floatTextField.backgroundColor = .white
        floatTextField.formattingMask = "#### #### #### ####"
        floatTextField.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        floatTextField.minimumFontSize = 36
        floatTextField.textPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 1)
        floatTextField.highlightsWhenActive = true
        floatTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        floatTextField.cornerRadius = 8
        floatTextField.showUnderlineView = false
        floatTextField.borderColor = .systemGreen
        floatTextField.borderWidth = 1
        floatTextField.placeholderColor = .systemGreen
        
        fixedWidthPhoneField.font = UIFont(name: "Avenir", size: 30)?.monospaced
        fixedWidthPhoneField.exampleMask = "+7 900 432 89 67"
        fixedWidthPhoneField.formattingMask =  "+7 ### ### ## ##"
        
//        fixedWidthPhoneField.exampleMask = "+31 (0) 20 76 06697"
//        fixedWidthPhoneField.phoneMask =  "+31 (#) ## ## #####"
        
        field_1.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        field_2.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)

        floatTextField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        fixedWidthPhoneField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        
        lettersField.showsMaskIfEmpty = false
        lettersField.formattingMask = "* ### ** ###"
        lettersField.exampleMask = "A 123 BB 456"
        lettersField.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.25)
        lettersField.font = UIFont(name: "Courier", size: 30)
        
        let testField = FormattingTextField()
        testField.formatter = DefaultFormatter(mask: "XYZ AB##")
        testField.exampleMask = "XYZ AB34"
        testField.font = .monospacedSystemFont(ofSize: 40, weight: .medium)
        testField.translatesAutoresizingMaskIntoConstraints = false
        testField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        lettersField.superview?.addSubview(testField)
        NSLayoutConstraint.activate([
            testField.topAnchor.constraint(equalTo: lettersField.bottomAnchor, constant: 8),
            testField.centerXAnchor.constraint(equalTo: lettersField.centerXAnchor)
        ])
    }
    
    @objc private func didChangeEditing(textField: UITextField) {
        guard let tf = textField as? FloatingLabelTextField else { return }
        let isError = tf.text!.count % 2 == 0
        tf.bottomText = isError ? "Incorrect card format" : nil
        tf.isError = isError
    }
    
    @objc func didTapClear() {
        floatingFieldNoFormatting.text = nil
    }
}


class MyTextField: FormattingTextField {
    override func formattedText(text: String?) -> String? {
        return text?.uppercased()
    }
}
