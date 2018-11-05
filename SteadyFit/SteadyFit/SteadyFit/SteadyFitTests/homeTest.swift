//
//  homeTest.swift
//  SteadyFitTests
//
//  Created by Raheem Mian on 2018-11-04.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

@testable import SteadyFit 
class homeTest: XCTestCase {
let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let textField = app.textFields["Email"]
        textField.tap()
        textField.typeText("cmpt275daycar@hotmail.com")
       // let textField2 = app.textFields["Password"]
        //textField2.tap()
       // textField2.typeText("herberttsang275")
       // app.buttons["Sign in"].tap()
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
