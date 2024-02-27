//
//  AcceptedLettersTests.swift
//  AGInputControlsTests
//
//  Created by Igor Vedeneev on 03.11.2021.
//

import XCTest
@testable import AGInputControls

class AcceptedLettersTests: XCTestCase {
    
    var textField: FormattingTextField!
    var delegate: MockTextFieldDelegate!
    
    override func setUp() {
        super.setUp()
        let formatter = DefaultFormatter(mask: "***", allowsEmptyOrNilStrings: true, acceptedLetters: Set("йцукенгшщзхъёфывапролджэячсмитьбю".uppercased()))
        textField = FormattingTextField()
        textField.formatter = formatter
        delegate = MockTextFieldDelegate()
        textField.formattingDelegate = delegate
    }
    
    func testFormattingMaskReturnsCorrectlyIfFormatterWasSetExplicitly() {
        XCTAssertEqual(textField.formattingMask, textField.formatter?.mask)
    }
    
    func testUnacceptedLettersDelegateMethodCalled() {
        textField.text = "gз"
        XCTAssertEqual(delegate.unacceptedCharCalled, 1)
    }
    
    
    func testNotifyingDelegateWithEmptyMaskAndNonEmptyString() {
        textField.formatter = EmptyMaskFormatter()
        textField.text = "gfhdskjfhdskjfhds"
        XCTAssertEqual(delegate.isValidCalled, 1)
        XCTAssertEqual(delegate.isValid, true)
    }
    
    func testNotifyingDelegateWithEmptyMaskAndEmptyString() {
        textField.formatter = EmptyMaskFormatter()
        textField.text = ""
        XCTAssertEqual(delegate.isValidCalled, 1)
        XCTAssertEqual(delegate.isValid, false)
    }
    
    override func tearDown() {
        super.tearDown()
        textField = nil
    }
}

class MockTextFieldDelegate: FormattingTextFieldDelegate {
    func textField(textField: FormattingTextField, didProduce text: String?, isValid: Bool) {
        isValidCalled += 1
        self.isValid = isValid
    }
    
    func textField(textField: FormattingTextField, didOccurUnacceptedCharacter char: Character) {
        unacceptedCharCalled += 1
    }
    
    var isValidCalled = 0
    var unacceptedCharCalled = 0
    var isValid = false
}

struct EmptyMaskFormatter: AGFormatter {
    var prefix: String = ""
    let mask = ""
    
    func isValidString(text: String?) -> Bool {
        !(text?.isEmpty ?? true)
    }
}
