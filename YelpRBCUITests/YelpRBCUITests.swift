//
//  YelpRBCUITests.swift
//  YelpRBCUITests
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import XCTest

class YelpRBCUITests: BaseUITestClass {
    
    func testUIForHome(){
        
        //Check if the collection view exists
        let resturantsListCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(resturantsListCollectionView.exists, "Collection view does not exist")
        
        //Check if cells exist
        let cell = resturantsListCollectionView.cells.firstMatch
        _ = cell.waitForExistence(timeout: 3.0)
        XCTAssertTrue(cell.exists)
        
        //check subviews
        XCTAssertTrue(cell.images["dishImage"].exists)
        XCTAssertEqual(cell.images.count, 1)
        
        XCTAssertTrue(cell.staticTexts["dishTitle"].exists)
        XCTAssertTrue(cell.staticTexts["dishRating"].exists)

        //check if search bar exists
        XCTAssertTrue(app.otherElements.searchFields.firstMatch.exists)
        
        //check navbar exists
        let navBar = app.navigationBars.firstMatch
        let restaurants = navBar.staticTexts.firstMatch
        XCTAssertEqual(restaurants.label, "Restaurants")
        
        let sortButton = navBar.buttons.firstMatch
        XCTAssertTrue(sortButton.exists)
    }
    
    
    func testUIForDetailScreen(){
        
        //Check if the collection view exists
        let resturantsListCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(resturantsListCollectionView.exists, "Collection view does not exist")
        
        //Check if cells exist
        let cell = resturantsListCollectionView.cells.firstMatch
        _ = cell.waitForExistence(timeout: 3.0)
        XCTAssertTrue(cell.exists)
        
        //tap cell
        cell.tap()
        
        //check subviews
        let navBar = app.navigationBars.firstMatch
        let restaurants = navBar.staticTexts.firstMatch
        XCTAssertEqual(restaurants.label, "DETAIL")
        
        XCTAssertTrue(app.images["detailDishImage"].exists)
        XCTAssertTrue(app.staticTexts["detailDishRating"].exists)
        XCTAssertTrue(app.staticTexts["detailAddress"].exists)
        XCTAssertTrue(app.staticTexts["detailPhoneNumber"].exists)
        XCTAssertTrue(app.buttons["detailCuisineButton"].exists)
        XCTAssertTrue(app.buttons["detailStatus"].exists)
        XCTAssertTrue(app.collectionViews.firstMatch.exists)
    }
    
    
    
    func testFunctionality(){
        
        //Check if the collection view exists
        let resturantsListCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(resturantsListCollectionView.exists, "Collection view does not exist")
        
        //Check if cells exist
        let cell = resturantsListCollectionView.cells.firstMatch
        _ = cell.waitForExistence(timeout: 3.0)
        XCTAssertTrue(cell.exists)
        
        //get cells title
        let restaurantTitle = cell.staticTexts["dishTitle"]
        let label = restaurantTitle.label
        XCTAssertTrue(restaurantTitle.exists)

        
        //tap cell
        cell.tap()
        
        //check for title label
        let detailTitle = app.staticTexts["detailTitle"].firstMatch
        XCTAssertTrue(detailTitle.exists)

        
        //check if the titles match
        let titleExpectation = waiterResultWithXCTCheckValueIsEqual(detailTitle, expectedText: label)
        XCTAssertTrue(titleExpectation == .completed)
            
        
    }
    
    func waiterResultWithXCTCheckValueIsEqual(_ element: XCUIElement, expectedText: String) -> XCTWaiter.Result {
        let myPredicate = NSPredicate(format: "label == '\(expectedText)'")
        let myExpectation = XCTNSPredicateExpectation(predicate: myPredicate,
                                                      object: element)
        let result = XCTWaiter().wait(for: [myExpectation], timeout: 60)
        return result
    }
    

   
}
