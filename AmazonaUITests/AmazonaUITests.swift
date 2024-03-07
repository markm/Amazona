//
//  AmazonaUITests.swift
//  AmazonaUITests
//
//  Created by Mark Mckelvie on 3/2/24.
//

import XCTest

final class AmazonaUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSearchBarAllowsTextEntry() {
        /// Given: the search bar
        let searchBar = app.textFields["SearchTextField"]
        
        /// When: the user is entering text
        searchBar.tap()
        searchBar.typeText("Test Search")
        
        /// Then: the search bar should contain the entered text
        XCTAssertEqual(searchBar.value as? String, "Test Search")
     }
}
