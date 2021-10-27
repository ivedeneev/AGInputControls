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
        textField.phoneMask = "+# ### ###-##-##"
        XCTAssertEqual(textField.prefix, "+#")
        
        textField.phoneMask = "+7 ### ###-##-##"
        XCTAssertEqual(textField.prefix, "+7")
        
        textField.phoneMask = "+232 ### ###-##-##"
        XCTAssertEqual(textField.prefix, "+232")
        
        textField.phoneMask = "232 ### ###-##-##"
        XCTAssertEqual(textField.prefix, "232")
        
        textField.phoneMask = "+31 (#) ## ## #####"
        XCTAssertEqual(textField.prefix, "+31")
        
        textField.phoneMask = "+## ### ### ## ###"
        textField.setFormattedText("+31 970 102 81 448")
        XCTAssertEqual(textField.text, "+31 970 102 81 448")
//    +442037691880
    }
    
    func testFormatting() {
        textField.phoneMask = "+31 (#) ## ## #####"
        let phone = "+31 (4) 10 20 76066"
        XCTAssertEqual(textField.formattedText(text: phone), phone)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
