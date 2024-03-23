//
//  FloatingLabelViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 05/03/2024.
//

import UIKit
import AGInputControls

extension StackViewController: FormattingTextFieldDelegate {
    func textField(textField: FormattingTextField, didProduce text: String?, isValid: Bool) {
        print(type(of: textField), text)
    }
    
    func textField(textField: FormattingTextField, didOccurUnacceptedCharacter char: Character) {
        print(type(of: textField), "did occur unaccepted char [\(char)]. Formatting mask:", textField.formattingMask)
    }
}

final class FloatingLabelViewController: StackViewController {
    
    let floatTextField = FloatingLabelTextField()
    let floatingFieldNoFormatting = FloatingLabelTextField()
    let floatingPhoneTextField = FloatingLabelTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingFieldNoFormatting.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        floatingFieldNoFormatting.bottomText = "Bottom text"
        floatingFieldNoFormatting.placeholder = "Floating placeholder"
        floatingFieldNoFormatting.showUnderlineView = true
        floatingFieldNoFormatting.highlightsWhenActive = true
        floatingFieldNoFormatting.clearButtonMode = .never
        floatingFieldNoFormatting.rightViewMode = .always
        
        let customClearButton = UIButton()
        customClearButton.backgroundColor = .systemPurple
        customClearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        customClearButton.tintColor = .lightGray
        customClearButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        floatingFieldNoFormatting.rightView = customClearButton
        
        floatingFieldNoFormatting.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        floatingFieldNoFormatting.leftView?.tintColor = .lightGray
        floatingFieldNoFormatting.leftViewMode = .always
        
        floatTextField.placeholder = "Card number"
        floatTextField.tintColor = .systemPurple
        floatTextField.backgroundColor = .white
        floatTextField.formattingMask = "#### #### #### ####"
        floatTextField.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        floatTextField.minimumFontSize = 36
        floatTextField.textPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        floatTextField.highlightsWhenActive = true
        floatTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        floatTextField.cornerRadius = 8
        floatTextField.showUnderlineView = false
        floatTextField.borderWidth = 1
        floatTextField.placeholderColor = .systemGreen
        floatTextField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        
        floatingPhoneTextField.placeholder = "Phone"
        floatingPhoneTextField.formatter = PhoneNumberFormatter(mask: "+7 (###) ### ##-##")
        floatingPhoneTextField.exampleMask = "+7 (123) 456 78-90"
//        floatingPhoneTextField.exampleMask = "+7 (___) ___ __-__"
        floatingPhoneTextField.exampleMask = "+7 ("
        floatingPhoneTextField.font = .systemFont(ofSize: 24)
        
        stackView.addArrangedSubview(Entry(title: "No formatting", targetView: floatingFieldNoFormatting, needsTrailingConstraint: true))
        stackView.addArrangedSubview(Entry(title: "Regular formatting", targetView: floatTextField))
        stackView.addArrangedSubview(Entry(title: "Phone floating textfield", targetView: floatingPhoneTextField))
    }
    
    
    @objc private func didChangeEditing(textField: UITextField) {
        guard let tf = textField as? FloatingLabelTextField else { return }
        let isError = tf.text!.count % 2 == 0
        tf.bottomText = isError ? "Incorrect card format" : nil
        tf.hasError = isError
    }
    
    @objc func didTapClear() {
        floatingFieldNoFormatting.text = nil
    }
}
