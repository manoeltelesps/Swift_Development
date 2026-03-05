//
//  TodoListUITests.swift
//  TodoListUITests
//
//  Created by Manoel Pedro Prado Sa Teles on 03/03/26.
//

import XCTest

final class TodoListUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func test_AddTask_FirstTime() throws {
        // UI tests must launch the application that they test.
            
        let app = XCUIApplication()
        app.activate()
        app.collectionViews/*@START_MENU_TOKEN@*/.firstMatch/*[[".containing(.cell, identifier: nil).firstMatch",".containing(.other, identifier: nil).firstMatch",".firstMatch"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Add Button"]/*[[".otherElements[\"Add Button\"].buttons",".otherElements",".buttons[\"Add\"]",".buttons[\"Add Button\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements.textFields[\"Type something here...\"]",".textFields",".textFields[\"Type something here...\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements",".textFields[\"Aaa\"]",".textFields[\"Type something here...\"]",".textFields"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("aaaa")

       
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func test_Title_Appearance() throws {
        let app = XCUIApplication()
        app.activate()
        
        app.staticTexts["VASCO"].firstMatch.tap()
      
        
//        XCTAssertFalse(app.navigationBars["Todo List 📝"].exists)
        
    }
    
    func test_AddTask_HasTaskExists() throws {
        //Arrange
        let app = XCUIApplication()
        
        //Act
        app.launch()
        app.otherElements[AccessibilityIdentifiers.addButton].firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements.textFields[\"Type something here...\"]",".textFields",".textFields[\"Type something here...\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements",".textFields[\"Teste o test\"]",".textFields[\"Type something here...\"]",".textFields"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("teste 2")
        app.buttons[AccessibilityIdentifiers.saveButton].firstMatch.tap()
        
        //Assert
        XCTAssertTrue(app.staticTexts["teste 2"].exists)
  
    }
    
    func test_AddTask_And_DeleteTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        app/*@START_MENU_TOKEN@*/.buttons["Add Button"]/*[[".otherElements[\"Add Button\"].buttons",".otherElements",".buttons[\"Add\"]",".buttons[\"Add Button\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app.windows.element(boundBy: 1).tap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements.textFields[\"Type something here...\"]",".textFields",".textFields[\"Type something here...\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.doubleTap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements",".textFields[\"Vai da cert\"]",".textFields[\"Type something here...\"]",".textFields"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("vai da certo")
        app/*@START_MENU_TOKEN@*/.buttons["Save Button"]/*[[".scrollViews.buttons",".otherElements",".buttons[\"SAVE\"]",".buttons[\"Save Button\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        XCTAssertTrue(app.staticTexts["vai da certo"].exists)
        
        app.cells.containing(.staticText, identifier: "vai da certo").firstMatch.swipeLeft()
        app/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".collectionViews.buttons",".otherElements.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        XCTAssertFalse(app.staticTexts["vai da certo"].exists)
    }
    
    func test_Persistence() throws {
        let app = XCUIApplication()
        
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["Add Button"]/*[[".otherElements[\"Add Button\"].buttons",".otherElements",".buttons[\"Add\"]",".buttons[\"Add Button\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements.textFields[\"Type something here...\"]",".textFields",".textFields[\"Type something here...\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Type something here..."]/*[[".otherElements",".textFields[\"Persistenci\"]",".textFields[\"Type something here...\"]",".textFields"],[[[-1,2],[-1,1],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("persistencia")
        app/*@START_MENU_TOKEN@*/.buttons["Save Button"]/*[[".scrollViews.buttons",".otherElements",".buttons[\"SAVE\"]",".buttons[\"Save Button\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        XCUIDevice.shared.press(.home)
        XCUIDevice.shared.press(.home)
        
        let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboardApp/*@START_MENU_TOKEN@*/.icons["Do Stuff"]/*[[".icons.icons[\"Do Stuff\"]",".icons[\"Do Stuff\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        XCTAssertTrue(app.staticTexts["persistencia"].exists)
    }
}
