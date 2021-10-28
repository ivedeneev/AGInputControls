//
//  DefaultFormatterTests.swift
//  AGInputControlsTests
//
//  Created by Igor Vedeneev on 28.10.2021.
//

import XCTest
@testable import AGInputControls

class DefaultFormatterTests: XCTestCase {
    
    var formatter: DefaultFormatter!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        formatter = nil
    }

    func testOnlyDigitsFormattingFormatting() throws {
        formatter = DefaultFormatter(mask: "#### ###############")
        let inputs = [
            ("1234 567890123456789", "1234 567890123456789"),
            ("1234567890123456789", "1234 567890123456789"),
            ("12345", "1234 5"),
            ("1234", "1234"),
            ("1234567890123456789000000000", "1234 567890123456789"),
        ]
        
        performFormattingTest(inputs: inputs)
    }
    
    func testDigitsAndLettersFormatting() {
        formatter = DefaultFormatter(mask: "*** ### * ##")
        let inputs = [
            ("ABV 444 L 12", "ABV 444 L 12"),
            ("ABV444L12", "ABV 444 L 12"),
            ("ABV ", "ABV"),
            ("ABV444L", "ABV 444 L"),
//            ("1234567890123456789000000000", "1234 567890123456789"),
        ]
        
        performFormattingTest(inputs: inputs)
    }
    
    func testValidation() {
        formatter = DefaultFormatter(mask: "#### ###")
        let inputs = [
//            ("1234 567", true),
            ("1234567", true),
            ("1234 56", false),
        ]
        
        performValidationTest(inputs: inputs)
    }
    
    /// - parameter data: tuple with input and expected strings
    func performFormattingTest(inputs: [(String, String)]) {
        inputs.forEach {
            XCTAssertEqual(formatter.formattedText(text: $0), $1, $0)
        }
    }
    
    func performValidationTest(inputs: [(String, Bool)]) {
        inputs.forEach {
            XCTAssertEqual(formatter.isValidString(text: $0), $1, $0)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

