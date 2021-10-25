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
    
    @IBOutlet weak var lettersField: MaskedTextField!
    
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
        phoneField.phoneMask = "+X (XXX) XXX-XX-XX"
        phoneField.exampleMask = "+7 (888) 777-66-55"
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
        
        fixedWidthPhoneField.font = UIFont(name: "Avenir", size: 30)?.monospaced
        fixedWidthPhoneField.exampleMask = "+7 900 432 89 67"
        fixedWidthPhoneField.phoneMask =  "+7 XXX XXX XX XX"
        
        fixedWidthPhoneField.exampleMask = "+31 (0) 20 76 06697"
        fixedWidthPhoneField.phoneMask =  "+31 (X) XX XX XXXXX"
        
        field_1.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        field_2.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)

        floatTextField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        fixedWidthPhoneField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        
        floatingFieldNoFormatting.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        floatingFieldNoFormatting.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        lettersField.formattingMask = "L DDD LL DDD"
        lettersField.exampleMask = "A 123 BB 456"
        lettersField.font = UIFont(name: "Courier", size: 30)
        
        let testField = MaskedTextField()
//        testField.formattingMask = "123 DDDDDDDDDD"
//        testField.exampleMask = "123 1234567890"
        testField.formattingMask = "XYZ DDDDDDDDDD"
        testField.exampleMask = "XYZ 1234567890"
        testField.font = UIFont(name: "Courier", size: 30)
        testField.translatesAutoresizingMaskIntoConstraints = false
        testField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        lettersField.superview?.addSubview(testField)
        NSLayoutConstraint.activate([
            testField.topAnchor.constraint(equalTo: lettersField.bottomAnchor, constant: 8),
            testField.centerXAnchor.constraint(equalTo: lettersField.centerXAnchor)
        ])
    }
    
    @objc private func didChangeEditing(textField: UITextField) {
        print(type(of: textField), textField.text ?? "NO_TEXT")
        guard let tf = textField as? FloatingLabelTextField else { return }
        tf.bottomText = tf.text!.count % 2 == 0 ? "Incorrect card format" : nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        fixedWidthPhoneField.setFormattedText("89153051653")
    }
}


class MyTextField: FormattingTextField {
    override func formattedText(text: String?) -> String? {
        return text?.uppercased()
    }
}
