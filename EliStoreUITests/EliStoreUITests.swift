//
//  EliStoreUITests.swift
//  EliStoreUITests
//
//  Created by Akash Verma on 15/07/22.
//

import XCTest
@testable import EliStore

class EliStoreUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        self.app = XCUIApplication()
        self.continueAfterFailure = false
        self.app.launchEnvironment = ["ENV": "TEST"]
        self.app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductAddToCartFlow() {
        
        let addToCartButton = app.buttons["Add To Cart"]
        XCTAssertTrue(!addToCartButton.isEnabled)
        wait(for: 2)
        
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iPhone 13 Pro Max")/*[[".cells.containing(.staticText, identifier:\"180000$\")",".cells.containing(.staticText, identifier:\"iPhone 13 Pro Max\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iPad")/*[[".cells.containing(.staticText, identifier:\"75000$\")",".cells.containing(.staticText, identifier:\"iPad\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
        XCTAssertTrue(addToCartButton.isEnabled)
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iPhone 13 Pro Max")/*[[".cells.containing(.staticText, identifier:\"180000$\")",".cells.containing(.staticText, identifier:\"iPhone 13 Pro Max\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Decrement"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iPad")/*[[".cells.containing(.staticText, identifier:\"75000$\")",".cells.containing(.staticText, identifier:\"iPad\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Decrement"].tap()
        XCTAssertTrue(!addToCartButton.isEnabled)
    }
    
    func testProductEndToEndFlow() {
        let addToCartButton = app.buttons["Add To Cart"]
        wait(for: 2)
        
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iPhone 13 Pro Max")/*[[".cells.containing(.staticText, identifier:\"180000$\")",".cells.containing(.staticText, identifier:\"iPhone 13 Pro Max\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iPhone 13 Pro Max")/*[[".cells.containing(.staticText, identifier:\"180000$\")",".cells.containing(.staticText, identifier:\"iPhone 13 Pro Max\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
        
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iPad")/*[[".cells.containing(.staticText, identifier:\"75000$\")",".cells.containing(.staticText, identifier:\"iPad\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iMac")/*[[".cells.containing(.staticText, identifier:\"110000$\")",".cells.containing(.staticText, identifier:\"iMac\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"iMac")/*[[".cells.containing(.staticText, identifier:\"110000$\")",".cells.containing(.staticText, identifier:\"iMac\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Increment"].tap()
        
        addToCartButton.tap()

        let confirmOrderButton = app.buttons["Confirm Order Placement"]
        XCTAssertTrue(!confirmOrderButton.isEnabled)
        
        let addressTextField = app.textFields["addressTextField"]
        addressTextField.tap()
        addressTextField.typeText("India")
        addressTextField.typeText("\n")
        
        XCTAssertTrue(confirmOrderButton.isEnabled)
        confirmOrderButton.tap()

        wait(for: 2)
        let DismissButton = app.staticTexts["Dismiss"]
        let successLabel = app.staticTexts["successLabel"]
        
        wait(for: 2)
        XCTAssertEqual(DismissButton.exists, true)
        XCTAssertEqual(successLabel.exists, true)

    }
}

extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }
    waitForExpectations(timeout: duration + 0.5)
  }
}
