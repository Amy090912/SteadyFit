//
//  HomeTest.swift
//  HomeTest
//
//  Created by Raheem Mian on 2018-11-04.
//  Copyright © 2018 Daycar. All rights reserved.
//

import XCTest

class HomeTest: XCTestCase {

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

    func testHistogram() {
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Histogram"]/*[[".cells.staticTexts[\"Histogram\"]",".staticTexts[\"Histogram\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Histogram"].buttons["Home"].tap()
        
     
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testEventA(){
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("cmpt275daycar@hotmail.com")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("herberttsang275")
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Event A"]/*[[".cells.staticTexts[\"Event A\"]",".staticTexts[\"Event A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Event A"].buttons["Home"].tap()
        
    }
    
    func testEventB(){
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("cmpt275daycar@hotmail.com")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("herberttsang275")
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Event B"]/*[[".cells.staticTexts[\"Event B\"]",".staticTexts[\"Event B\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let eventBNavigationBar = app.navigationBars["Event B"]
        eventBNavigationBar.buttons["Home"].tap()
    }
    
    func testEventC(){
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("cmpt275daycar@hotmail.com")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("herberttsang275")
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.otherElements.containing(.button, identifier:"Sign in").children(matching: .button)["Sign in"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Event C"]/*[[".cells.staticTexts[\"Event C\"]",".staticTexts[\"Event C\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Event C"].buttons["Home"].tap()
        
    }

}
