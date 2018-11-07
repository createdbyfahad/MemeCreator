//
//  MemeCreatorUITests.swift
//  MemeCreatorUITests
//
//  Created by Fahad Alarefi on 8/3/18.
//  Copyright © 2018 createdbyFahad. All rights reserved.
//

import XCTest

class MemeCreatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddCategory() {
        let app = XCUIApplication()
        let mainNavigationBar = app.navigationBars["Meme Categories"]
        XCTAssert(mainNavigationBar.exists, "can't find the main view")
        let existsPredicate = NSPredicate(format: "exists == TRUE")
        expectation(for: existsPredicate, evaluatedWith: mainNavigationBar,
                    handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        let addButton = mainNavigationBar.buttons["Add"]
        XCTAssert(addButton.exists, "can't find the add button")
        
        addButton.tap()
        
        let textField = app.textFields["categoryTextField"]
        XCTAssert(textField.exists, "can't find the category add textfield")
        textField.tap()
        guard let currentText = textField.value as? String else{
            XCTFail("can't get the add category text")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count)
        textField.typeText(deleteString)
        textField.typeText("Test Category")
        
        app.navigationBars["Add Category"].buttons["Save"].tap()
        
        let categoriesTableView = app.tables
        XCTAssertGreaterThan(categoriesTableView.count, 0, "can't find the categories table")
        
        let categoriesTable = categoriesTableView.firstMatch
        XCTAssertGreaterThan(categoriesTable.cells.count, 0, "category table has no rows")
        
        let cell = categoriesTable.cells.staticTexts["Test Category"].firstMatch
        XCTAssert(cell.exists, "can't find the added category")
        cell.tap()
        
    }
    
    func testEditCategory() {
        let app = XCUIApplication()
        let mainNavigationBar = app.navigationBars["Meme Categories"]
        XCTAssert(mainNavigationBar.exists, "can't find the main view")
        let existsPredicate = NSPredicate(format: "exists == TRUE")
        expectation(for: existsPredicate, evaluatedWith: mainNavigationBar,
                    handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        let addButton = mainNavigationBar.buttons["Add"]
        XCTAssert(addButton.exists, "can't find the add button")
        
        addButton.tap()
        
        var textField = app.textFields["categoryTextField"]
        XCTAssert(textField.exists, "can't find the category add textfield")
        textField.tap()
        guard let currentText = textField.value as? String else{
            XCTFail("can't get the add category text")
            return
        }
        var deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count)
        textField.typeText(deleteString)
        textField.typeText("Test Category Edit")
        
        app/*@START_MENU_TOKEN@*/.keyboards.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Add Category"].buttons["Save"].tap()
        
        let categoriesTableView = app.tables
        XCTAssertGreaterThan(categoriesTableView.count, 0, "can't find the categories table")
        
        let categoriesTable = categoriesTableView.firstMatch
        XCTAssertGreaterThan(categoriesTable.cells.count, 0, "category table has no rows")
        
        var cell = categoriesTable.cells.staticTexts["Test Category Edit"].firstMatch
        XCTAssert(cell.exists, "can't find the added category")
        
        // activate edit button
        let editButton = mainNavigationBar.buttons["Edit"]
        XCTAssert(editButton.exists, "can't find the edit button")
        editButton.tap()
        cell.tap()
        
        
        textField = app.textFields["categoryTextField"]
        XCTAssert(textField.exists, "can't find the category edit textfield")
        textField.tap()
        guard let currentText2 = textField.value as? String else{
            XCTFail("can't get the edit category text")
            return
        }
        deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText2.count)
        textField.typeText(deleteString)
        textField.typeText("Test Category New Edit")
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        cell = categoriesTable.cells.staticTexts["Test Category New Edit"].firstMatch
        XCTAssert(cell.exists, "can't find the added category")
    }
    
    func testDeleteCategories() {
        let app = XCUIApplication()
        let mainNavigationBar = app.navigationBars["Meme Categories"]
        XCTAssert(mainNavigationBar.exists, "can't find the main view")
        let existsPredicate = NSPredicate(format: "exists == TRUE")
        expectation(for: existsPredicate, evaluatedWith: mainNavigationBar,
                    handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        let addButton = mainNavigationBar.buttons["Add"]
        XCTAssert(addButton.exists, "can't find the add button")
        
        addButton.tap()
        
        let textField = app.textFields["categoryTextField"]
        XCTAssert(textField.exists, "can't find the category add textfield")
        textField.tap()
        guard let currentText = textField.value as? String else{
            XCTFail("can't get the add category text")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count)
        textField.typeText(deleteString)
        textField.typeText("Test Category Delete")
        
        app/*@START_MENU_TOKEN@*/.keyboards.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Add Category"].buttons["Save"].tap()
        let categoriesTableView = app.tables
        XCTAssertGreaterThan(categoriesTableView.count, 0, "can't find the categories table")
        
        let categoriesTable = categoriesTableView.firstMatch
        XCTAssertGreaterThan(categoriesTable.cells.count, 0, "category table has no rows")
        
        let cell = categoriesTable.cells.staticTexts["Test Category Delete"].firstMatch
        XCTAssert(cell.exists, "can't find the added category")
        
        let cells = categoriesTable.cells
        // delete all cells
        while cells.count > 0{
            cells.element(boundBy: 0).swipeLeft()
            cells.element(boundBy: 0).buttons["Remove It!"].tap()
        }
        
        // make sure that there no cells anymore
        
        XCTAssertEqual(cells.count, 0, "failed to delete all categories")

    }
    
    func testPickBackgroundFromList(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Create"].tap()
        
        let image = app.images["addImage"].firstMatch
        XCTAssert(image.exists, "can't find the add meme image area")
        
        image.tap()
        
        let sheet = app.sheets["Image Source"]
        XCTAssert(sheet.exists, "can't find the add meme image action sheet")
        
        let photoLibrary = sheet.buttons["Photo Library"]
        let chooseFromList = sheet.buttons["Choose from list"]
        XCTAssert(photoLibrary.exists, "can't find the 'Photo Library' in action sheet")
        XCTAssert(chooseFromList.exists, "can't find the 'Choose from list' in action sheet")
        
        chooseFromList.tap()
        
        let collectionView = app.collectionViews.firstMatch
        XCTAssert(collectionView.exists, "can't find the pick image collection view")
        XCTAssertGreaterThan(collectionView.cells.count, 0, "Theres are no meme backgrounds to pick from")
        
        collectionView.cells.firstMatch.tap()
        
        let button = app.buttons["Clear"].firstMatch
        XCTAssert(button.exists, "can't find a button")
        
    }
    
    
    func testAddCategoryFromCreate(){
        let app = XCUIApplication()
        app.tabBars.buttons["Create"].tap()
        
        let addButton = app.buttons["addCategoryButton"].firstMatch
        XCTAssert(addButton.exists, "can't find the add category button")
        addButton.tap()
        
        let textField = app.textFields["categoryTextField"].firstMatch
        XCTAssert(textField.exists, "can't find the category add textfield")
        textField.tap()
        guard let currentText = textField.value as? String else{
            XCTFail("can't get the add category text")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count)
        textField.typeText(deleteString)
        textField.typeText("Category added from create tab")
        
        app.navigationBars["Add Category"].buttons["Save"].tap()
        
        let pickCategory = app.textFields["chooseCategory"].firstMatch
        XCTAssert(pickCategory.exists, "can't find the pick category field")
        pickCategory.tap()
        
        let pickerWheel = app.pickerWheels.firstMatch
        XCTAssert(pickerWheel.exists, "can't find the pick category picker wheel")
        
        pickerWheel.adjust(toPickerWheelValue: "Category added from create tab")
        
        let textFieldValue = app.textFields["chooseCategory"].value as? String ?? ""
        
        XCTAssertEqual(textFieldValue, "Category added from create tab", "failed to choose the new categoy")
        
        let doneButton = app.toolbars.buttons["Done"]
        XCTAssert(doneButton.exists, "can't find the done button")
        
        doneButton.tap()
    }
    
    func testCreateTextFields() {
        let app = XCUIApplication()
        app.tabBars.buttons["Create"].tap()
        
        let topTextField = app.textFields["topTextField"]
        let buttomTextField = app.textFields["buttomTextField"]
        
        XCTAssert(topTextField.exists, "can't find the top textfield")
        XCTAssert(buttomTextField.exists, "can't find the buttom textfield")
        
        topTextField.tap()
        
        guard let currentText = topTextField.value as? String else{
            XCTFail()
            return
        }
        var deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText.count)
        topTextField.typeText(deleteString)
        topTextField.typeText("Test Top Text")
        
        buttomTextField.tap()
        
        guard let currentText2 = topTextField.value as? String else{
            XCTFail()
            return
        }
        deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentText2.count)
        buttomTextField.typeText(deleteString)
        buttomTextField.typeText("Test Buttom Text")
        
        app.keyboards.buttons["Done"].tap()
        
        let topTextFieldValue = topTextField.value as? String ?? ""
        let buttomTextFieldValue = buttomTextField.value as? String ?? ""
        
        XCTAssertEqual(topTextFieldValue, "Test Top Text", "failed to type top text")
        XCTAssertEqual(buttomTextFieldValue, "Test Buttom Text", "failed to type buttom text")
    }
    
    func testClearMeme() {
        testPickBackgroundFromList()
        testAddCategoryFromCreate()
        testCreateTextFields()
        
        let app = XCUIApplication()
        
        // tap the clear button
        let clearButton = app.buttons["Clear"]
        XCTAssert(clearButton.exists, "can't find the clear button in create tab")
        
        clearButton.tap()
    }
    
    func testAddMeme() {
        testPickBackgroundFromList()
        testAddCategoryFromCreate()
        testCreateTextFields()
        
        let app = XCUIApplication()
        
        // tap the save button
        let saveButton = app.buttons["Save"]
        XCTAssert(saveButton.exists, "can't find the save button in create tab")
        
        saveButton.tap()
        
        // dismiss the alert
        let clearButton = app.alerts.buttons["Clear"]
        XCTAssert(clearButton.exists, "can't find the clear button in create tab alert")
        
        // now move to the main tab
        app.tabBars.buttons["Gallery"].tap()
        
        let categoriesTableView = app.tables
        XCTAssertGreaterThan(categoriesTableView.count, 0, "can't find the categories table")
        
        let categoriesTable = categoriesTableView.firstMatch
        XCTAssertGreaterThan(categoriesTable.cells.count, 0, "category table has no rows")
        
        let cell = categoriesTable.cells.staticTexts["Category added from create tab"].firstMatch
        XCTAssert(cell.exists, "can't find the added category")
        cell.tap()
        
        let collectionView = app.collectionViews.firstMatch
        XCTAssert(collectionView.exists, "can't find the collection view")
        XCTAssertGreaterThan(collectionView.cells.count, 0, "Failed to add the meme ")
        
        //collectionView.cells.firstMatch.tap()
    }
    
    func testDeleteMeme(){
        testAddMeme()
        let app = XCUIApplication()
        // get the current count of memes
        let collectionView = app.collectionViews.firstMatch
        XCTAssert(collectionView.exists, "can't find the collection view")
        let currentCount = collectionView.cells.count
        
        collectionView.cells.firstMatch.tap()
        
        let deleteButton = app.toolbars.buttons["Delete"]
        XCTAssert(deleteButton.exists, "can't find the delete button")
        deleteButton.tap()
        
        let currentCount2 = collectionView.cells.count
        XCTAssertLessThan(currentCount2, currentCount, "Failed to delete a meme ")
    }
    
    func testAboutTab(){
        let app = XCUIApplication()
        app.tabBars.buttons["About"].tap()
        
        let mainTitle = app.staticTexts["What's MemeCreator?"].firstMatch
        XCTAssert(mainTitle.exists, "can't find the What's MemeCreator? section in about tab")
        
        let mainTitle2 = app.staticTexts["How to use?"].firstMatch
        XCTAssert(mainTitle2.exists, "can't find the How to use? section in about tab")
        
    }
    
    
}
