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
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
