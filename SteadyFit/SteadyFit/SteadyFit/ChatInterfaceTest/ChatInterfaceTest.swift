//
//  ChatInterfaceTest.swift
//  ChatInterfaceTest
//
//  Created by Raheem Mian on 2018-11-05.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class ChatInterfaceTest: XCTestCase {

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

    func testExample() {
        
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.tabBars.buttons["Chats"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Public: Vancouver, Light"]/*[[".cells.staticTexts[\"Public: Vancouver, Light\"]",".staticTexts[\"Public: Vancouver, Light\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["Enter message..."].tap()
        app.buttons["Send"].tap()
        app.navigationBars["Public Group: Vancouver, light"].buttons["Chat"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
