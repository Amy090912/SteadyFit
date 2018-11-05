//
//  FriendsTest.swift
//  FriendsTest
//
//  Created by Raheem Mian on 2018-11-04.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class FriendsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFriends() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("cmpt275daycar@hotmail.com")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("herberttsang275")
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.tabBars.buttons["Friends"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Friend A"]/*[[".cells.staticTexts[\"Friend A\"]",".staticTexts[\"Friend A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Friend A"].buttons["Friends"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Friend B"]/*[[".cells.staticTexts[\"Friend B\"]",".staticTexts[\"Friend B\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Friend B"].buttons["Friends"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Friend C"]/*[[".cells.staticTexts[\"Friend C\"]",".staticTexts[\"Friend C\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Friend C"].buttons["Friends"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Friend D"]/*[[".cells.staticTexts[\"Friend D\"]",".staticTexts[\"Friend D\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Friend D"].buttons["Friends"].tap()
    }

}
