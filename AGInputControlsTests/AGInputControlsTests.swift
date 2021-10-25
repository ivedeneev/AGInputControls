//
//  AGInputControlsTests.swift
//  AGInputControlsTests
//
//  Created by Igor Vedeneev on 6/24/21.
//

import XCTest
@testable import AGInputControls

class AGInputControlsTests: XCTestCase {
    
    var textField: OTPCodeTextField!
    
    override class func setUp() {
        super.setUp()
    }

    func testExample() throws {
        XCTAssertEqual("+31 970 102 81 448".formattedNumber(mask: "+## ### ###-##-##"), "+31 970 102 81 448", "fdfdf")
//    +442037691880
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
