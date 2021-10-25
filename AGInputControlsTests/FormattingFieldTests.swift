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
        
        textField.formattingMask = "+31 (#) ## ## #####"
        XCTAssertEqual(textField.prefix, "+31")
    }
    
    func testFormatting() {
        textField.formattingMask = "XYZ **########"
        
        XCTAssertEqual(textField.formattedText(text: "XYZLD443"), "XYZ LD443")
        XCTAssertEqual(textField.formattedText(text: "XYZ443"), "XYZ")
        XCTAssertEqual(textField.formattedText(text: "XYZ "), "XYZ")
    }
}
