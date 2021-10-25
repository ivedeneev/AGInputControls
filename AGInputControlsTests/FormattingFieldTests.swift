//
//  FormattingFieldTests.swift
//  AGInputControlsTests
//
//  Created by Igor Vedeneev on 25.10.2021.
//

import XCTest
@testable import AGInputControls

class FormattingFieldTests: XCTestCase {
    
    var textField: FormattingTextField!
    
    override func setUp() {
        super.setUp()
        textField = FormattingTextField()
    }

    func testPrefixes() throws {
        textField.formattingMask = "XYZ **########"
        XCTAssertEqual(textField.prefix, "XYZ")
        
        textField.formattingMask = "*** **########"
        XCTAssertEqual(textField.prefix, "***")
        
        textField.formattingMask = "*/* **########"
        XCTAssertEqual(textField.prefix, "*")
    }
}
