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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual("+31 970 102 81 448".formattedNumber(mask: "+XX XXX XXX-XX-XX"), "+31 970 102 81 448", "fdfdf")
//    +442037691880
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
