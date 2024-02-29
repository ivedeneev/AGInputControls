//
//  ViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 6/24/21.
//

import UIKit
import AGInputControls
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var lettersField: FormattingTextField!
    let fixedLettersPrefixField = FormattingTextField()
    @IBOutlet weak var otpFieldWithConstrainedWidth: OTPCodeTextField!
    @IBOutlet weak var otpFieldWithAutoWidth: OTPCodeTextField!
    @IBOutlet weak var adaptiveWidthPhoneField: PhoneTextField!
    @IBOutlet weak var fixedWidthPhoneField: PhoneTextField!
    @IBOutlet weak var floatTextField: FloatingLabelTextField!
    @IBOutlet weak var floatingFieldNoFormatting: FloatingLabelTextField!
    
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lettersField.showsMaskIfEmpty = false
        lettersField.formattingMask = "* ### ** ###"
        lettersField.exampleMask = "A 123 BB 456"
        lettersField.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.25)
        lettersField.font = UIFont(name: "Courier", size: 30)
        lettersField.formattingDelegate = self
        
        fixedLettersPrefixField.formatter = DefaultFormatter(mask: "XYZ AB##")
        fixedLettersPrefixField.exampleMask = "XYZ AB34"
        fixedLettersPrefixField.font = .monospacedSystemFont(ofSize: 40, weight: .medium)
        fixedLettersPrefixField.translatesAutoresizingMaskIntoConstraints = false
        fixedLettersPrefixField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        lettersField.superview?.addSubview(fixedLettersPrefixField)
        NSLayoutConstraint.activate([
            fixedLettersPrefixField.topAnchor.constraint(equalTo: lettersField.bottomAnchor, constant: 8),
            fixedLettersPrefixField.centerXAnchor.constraint(equalTo: lettersField.centerXAnchor)
        ])
        
        adaptiveWidthPhoneField.font = UIFont(name: "Menlo", size: 30)
        adaptiveWidthPhoneField.formattingMask = "+7 (###) ###-##-##"
        adaptiveWidthPhoneField.exampleMask = "+7 (___) ___-__-__"
        adaptiveWidthPhoneField.formattingDelegate = self
        
        adaptiveWidthPhoneField
            .publisher(for: \.text)
            .sink { text in
                print("Value from publisher", text)
            }
            .store(in: &cancellables)
        
        fixedWidthPhoneField.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        fixedWidthPhoneField.formattingMask = "+7 ### ### ## ##"
        fixedWidthPhoneField.exampleMask = "+7 123 456 78 90"
        fixedWidthPhoneField.backgroundColor = UIColor.systemPink.withAlphaComponent(0.1)
        fixedWidthPhoneField.textAlignment = .center
        fixedWidthPhoneField.clearButtonMode = .whileEditing
        
        floatingFieldNoFormatting.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        floatingFieldNoFormatting.bottomText = "Test"
        floatingFieldNoFormatting.showUnderlineView = true
        floatingFieldNoFormatting.highlightsWhenActive = true
        floatingFieldNoFormatting.clearButtonMode = .never
        floatingFieldNoFormatting.rightViewMode = .always
        
        let customClearButton = UIButton()
//        customClearButton.backgroundColor = .systemPurple
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
        floatTextField.textPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 1)
        floatTextField.highlightsWhenActive = true
        floatTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        floatTextField.cornerRadius = 8
        floatTextField.showUnderlineView = false
        floatTextField.borderWidth = 1
        floatTextField.placeholderColor = .systemGreen
        floatTextField.addTarget(self, action: #selector(didChangeEditing), for: .editingChanged)
        
        otpFieldWithAutoWidth.borderStyle = .none
        otpFieldWithAutoWidth.backgroundColor = .secondarySystemBackground
        otpFieldWithAutoWidth.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        otpFieldWithAutoWidth.decorationColor = UIColor.systemBlue.withAlphaComponent(0.1)
        otpFieldWithAutoWidth.decoration = .rect
        otpFieldWithAutoWidth.letterSpacing = 24
        otpFieldWithAutoWidth.length = 4
        otpFieldWithAutoWidth.font = UIFont(name: "Avenir", size: 30)?.monospaced
//        otpFieldWithAutoWidth.showsCaret = false
        
        otpFieldWithConstrainedWidth.font = .monospacedDigitSystemFont(ofSize: 30, weight: .light)
        otpFieldWithConstrainedWidth.decoration = .dash
        otpFieldWithConstrainedWidth.showsCaret = true
        otpFieldWithConstrainedWidth.decorationColor = .systemRed
        otpFieldWithConstrainedWidth.backgroundColor = .secondarySystemBackground
        
        title = "AGInputControls Examples"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .init(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(moreActions))
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
    
    @objc func moreActions() {
        let ac = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(.init(title: "Paste phone", style: .default, handler: { [unowned self] _ in
            adaptiveWidthPhoneField.text = "+79999999999"
        }))
        
        ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
}

extension ViewController: FormattingTextFieldDelegate {
    func textField(textField: FormattingTextField, didProduce text: String?, isValid: Bool) {
        print(type(of: textField), text)
    }
    
    func textField(textField: FormattingTextField, didOccurUnacceptedCharacter char: Character) {
        print(type(of: textField), "did occur unaccepted char [\(char)]. Formatting mask:", textField.formattingMask)
    }
}


class MyTextField: FormattingTextField {
    override func formattedText(text: String?) -> String? {
        return text?.uppercased()
    }
}

extension UITextField {
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
  }
