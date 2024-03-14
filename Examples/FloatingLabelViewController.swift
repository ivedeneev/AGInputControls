//
//  FloatingLabelViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 05/03/2024.
//

import UIKit
import AGInputControls

class StackViewController: UIViewController {
    
    var row: MenuViewController.Row!
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
        stackView.backgroundColor = .systemGroupedBackground
        title = row.label
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 1
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    final class Entry: UIView {
        
        let title: String
        let view: UIView
        
        init(title: String, targetView: UIView) {
            self.title = title
            self.view = targetView
            super.init(frame: .zero)
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .systemBackground
            
            let titleLabel = UILabel()
            addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
//            titleLabel.font = .preferredFont(forTextStyle: .title3)
            titleLabel.text = title
            
            NSLayoutConstraint.activate([
//                leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                trailingAnchor.constraint(equalTo: view.trailingAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
                
                titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -16),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

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
        
        stackView.addArrangedSubview(Entry(title: "No formatting", targetView: floatingFieldNoFormatting))
        
        stackView.addArrangedSubview(Entry(title: "Regular formatting", targetView: floatTextField))
        
        stackView.addArrangedSubview(Entry(title: "Phone floating textfield", targetView: floatingPhoneTextField))
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
