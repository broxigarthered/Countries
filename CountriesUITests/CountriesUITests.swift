//
//  CountriesUITests.swift
//  CountriesUITests
//
//  Created by Nikolay N. Dutskinov on 19.03.23.
//

import XCTest

final class CountriesUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app = nil
    }
    
    func testCountriesListDisplayed() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "Table view not found")
        XCTAssertTrue(tableView.cells.element.waitForExistence(timeout: 1.0))
    }
    
    func testTableViewExists() {
        let tableViewExists = app.tables.firstMatch.waitForExistence(timeout: 1.0)
        XCTAssertTrue(tableViewExists)
    }
    
    func testNavigationBarExists() {
        let navigationbarName = "World countries 🇧🇬🇩🇪🇺🇸🇦🇩"
        let navigationBar = app.navigationBars[navigationbarName]
        XCTAssertTrue(navigationBar.exists, "Navigation bar does not exists")
    }
    
    func testIfNavigationBarHasSearchField() {
        let navigationbarName = "World countries 🇧🇬🇩🇪🇺🇸🇦🇩"
        let searchField = app.navigationBars[navigationbarName].searchFields.firstMatch
        XCTAssertTrue(searchField.exists, "Search field does not exist in the navigation bar")
        XCTAssertEqual(searchField.placeholderValue, "Enter at least 3 characters")
    }
    
    func testSearchFunctionality() {
        let navigationbarName = "World countries 🇧🇬🇩🇪🇺🇸🇦🇩"
        let searchField = app.navigationBars[navigationbarName].searchFields.firstMatch
        XCTAssertTrue(searchField.exists, "Search text field not found")
        
        let tableView = app.tables.firstMatch.waitForExistence(timeout: 1.0)
        XCTAssertTrue(tableView)
        
        searchField.tap()
        searchField.typeText("bul")
        
        let filteredCells = app.tables.cells
        XCTAssertTrue(filteredCells.count == 1)
        app.buttons["Cancel"].tap()
        XCTAssertEqual(searchField.placeholderValue, "Enter at least 3 characters")
    }
    
    func testCellTap_opens_CountryDetails() {
        let tableViewExists = app.tables.firstMatch.waitForExistence(timeout: 1.0)
        XCTAssertTrue(tableViewExists)
        
        let tableView = app.tables.firstMatch
        let cells = tableView.cells.element
        XCTAssertTrue(cells.accessibilityElementCount() > 0)
        
        let firstCell = tableView.cells.firstMatch
        // taps on China
        firstCell.tap()
        
        let detailViewController = app.navigationBars["China"]
        XCTAssertTrue(detailViewController.exists, "The Country Details screen is not displayed")
        
        XCTAssertTrue(app.staticTexts["Flag"].exists)
        XCTAssertTrue(app.staticTexts["Map"].exists)
        XCTAssertTrue(app.staticTexts["Country Name -"].exists)
        XCTAssertTrue(app.staticTexts["Region -"].exists)
        XCTAssertTrue(app.staticTexts["Population -"].exists)
        XCTAssertTrue(app.staticTexts["Capital -"].exists)
    }
    
}
