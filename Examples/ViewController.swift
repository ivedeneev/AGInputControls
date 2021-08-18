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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BG")
        field_1.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        field_1.decoration = .rect
        
        field_2.borderStyle = .none
        field_2.backgroundColor = .white
        field_2.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        field_2.decoration = .dash
        field_2.letterSpacing = 8
        field_2.length = 6
        field_2.font = UIFont(name: "Avenir", size: 30)?.monospaced
        
        phoneField.backgroundColor = .systemBackground
        phoneField.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        phoneField.phoneMask = "+X (XXX) XXX-XX-XX"
        
        floatTextField.placeholder = "Card number"
        floatTextField.tintColor = .systemPink
        floatTextField.backgroundColor = .white
        floatTextField.formattingMask = "XXXX XXXX XXXX XXXX"
        floatTextField.font = .monospacedDigitSystemFont(ofSize: 18, weight: .thin)
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
