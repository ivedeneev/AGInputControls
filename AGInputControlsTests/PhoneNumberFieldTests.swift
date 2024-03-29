//
//  PhoneNumberFieldTests.swift
//  AGInputControlsTests
//
//  Created by Igor Vedeneev on 25.10.2021.
//

import XCTest
@testable import AGInputControls

class PhoneNumberFieldTests: XCTestCase {
    
    var textField: PhoneTextField!
    
    override func setUp() {
        super.setUp()
        textField = PhoneTextField()
    }

    func testExample() throws {
        textField.formattingMask = "+# ### ###-##-##"
        XCTAssertEqual(textField.prefix, "+#")
        
        textField.formattingMask = "+7 ### ###-##-##"
        XCTAssertEqual(textField.prefix, "+7")
        
        textField.formattingMask = "+232 ### ###-##-##"
        XCTAssertEqual(textField.prefix, "+232")
        
        textField.formattingMask = "232 ### ###-##-##"
        XCTAssertEqual(textField.prefix, "232")
        
        textField.formattingMask = "+31 (#) ## ## #####"
        XCTAssertEqual(textField.prefix, "+31")
        
        textField.formattingMask = "+## ### ### ## ###"
        textField.text = "+31 970 102 81 448"
        XCTAssertEqual(textField.text, "+31 970 102 81 448")
        
//    +442037691880
    }
    
    func testReplacing8withPlus7ForRussianNumbersIfConstantMaskWasSet() {
        textField.formattingMask = "+7 ### ###-##-##"
        textField.text = "89153051653"
        XCTAssertEqual(textField.text, "+7 915 305-16-53")
    }
    
    func testFormatting() {
        textField.formattingMask = "+31 (#) ## ## #####"
        let phone = "+31 (4) 10 20 76066"
        XCTAssertEqual(textField.formattedText(text: phone), phone)
    }
    
    func testRussianPhones() {
        textField.formattingMask = "+7 ### ###-##-##"
        textField.text = "79250441416"
        XCTAssertEqual(textField.text, "+7 925 044-14-16")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
