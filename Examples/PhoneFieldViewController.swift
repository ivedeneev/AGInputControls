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
    let test = PhoneTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.addArrangedSubview(Entry(title: "Free width", targetView: adaptiveWidthPhoneField))
        adaptiveWidthPhoneField.font = .systemFont(ofSize: 30)
//        adaptiveWidthPhoneField.font = .monospacedDigitSystemFont(ofSize: 30, weight: .regular)
        adaptiveWidthPhoneField.font = UIFont(name: "Courier", size: 30)
        adaptiveWidthPhoneField.formattingMask = "+7 (###) ###-##-##"
//        adaptiveWidthPhoneField.exampleMask = "+7 (___) ___-__-__"
        adaptiveWidthPhoneField.exampleMask = "+7 (000) 000-00-00"
        adaptiveWidthPhoneField.formattingDelegate = self
        adaptiveWidthPhoneField.textPadding = .init(top: 20, left: 8, bottom: 60, right: 8)
        
        test
    }
}
