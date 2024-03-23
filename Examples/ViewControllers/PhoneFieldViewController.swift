//
//  PhoneFieldViewController.swift
//  Examples
//
//  Created by Igor Vedeneev on 06/03/2024.
//

import UIKit
import AGInputControls

final class PhoneFieldViewController: StackViewController {
    
    let adaptiveWidthPhoneField = PhoneTextField()
    let fixedWidthPhoneField = PhoneTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.addArrangedSubview(Entry(title: "Free width, left alignment, custom insets", targetView: adaptiveWidthPhoneField))
        adaptiveWidthPhoneField.font = .systemFont(ofSize: 30)
        adaptiveWidthPhoneField.font = .monospacedDigitSystemFont(ofSize: 30, weight: .thin)
//        adaptiveWidthPhoneField.font = UIFont(name: "Courier", size: 30)
        adaptiveWidthPhoneField.formattingMask = "+7 (###) ###-##-##"
//        adaptiveWidthPhoneField.exampleMask = "+7 (___) ___-__-__"
        adaptiveWidthPhoneField.exampleMask = "+7 (000) 000-00-00"
        adaptiveWidthPhoneField.formattingDelegate = self
        adaptiveWidthPhoneField.textPadding = .init(top: 20, left: 8, bottom: 8, right: 8)
        
        let entry = Entry(title: "Fixed width, center alignment", targetView: fixedWidthPhoneField, needsTrailingConstraint: true)
        stackView.addArrangedSubview(entry)
        fixedWidthPhoneField.font = .monospacedDigitSystemFont(ofSize: 24, weight: .ultraLight)
//        fixedWidthPhoneField.font = .systemFont(ofSize: 24, weight: .ultraLight)
        fixedWidthPhoneField.formattingMask = "+7 (###) ###-##-##"
        fixedWidthPhoneField.exampleMask = "+7 (___) ___-__-__"
//        fixedWidthPhoneField.exampleMask = "+7 (123) 456-78-90"
        fixedWidthPhoneField.backgroundColor = UIColor.systemPink.withAlphaComponent(0.1)
        fixedWidthPhoneField.textAlignment = .center
        fixedWidthPhoneField.clearButtonMode = .whileEditing
    }
}
