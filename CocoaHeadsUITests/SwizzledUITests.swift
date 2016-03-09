//
//  SwizzleHttpServerUITests.swift
//  CocoaHeads
//
//  Created by Erik Sundin on 02/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import XCTest
import OHHTTPStubs

/**
* This test will not work since UITests won't be able to access the app bunlde in the same was as a normal hosted test would.
*/
class SwizzleHttpServerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Stub the request
        OHHTTPStubs.stubRequestsPassingTest({ (request) -> Bool in
            
            return request.URL!.path!.containsString("/2/events")
            
            }) { (request) -> OHHTTPStubsResponse in
                
                let json = OHPathForFile("events.json", self.dynamicType)
                return OHHTTPStubsResponse(fileAtPath: json!, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
        
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchEnvironment = ["UITests" : "true"]
        app.launch()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Remove stubs
        OHHTTPStubs.removeAllStubs()
    }
    
    func testBrowseMeetup() {
        
        let app = XCUIApplication()
        
        // Assert title
        XCTAssert(app.staticTexts["Meetups"].exists)
        
        let meetupCell = app.tables.staticTexts["Test Meetup"]
        expectationForPredicate(NSPredicate(format: "exists == true"), evaluatedWithObject: meetupCell, handler: nil)
        waitForExpectationsWithTimeout(3.0, handler: nil)
        
        // Assert contents in the list
        XCTAssertTrue(meetupCell.exists)
        XCTAssertTrue(app.tables.staticTexts["2016-01-01 at 13:37"].exists)
        
        // Go into details
        app.tables.staticTexts["Test Meetup"].tap()
        
        // Assert title
        XCTAssert(app.staticTexts["Test Meetup"].exists)
        
        // Go Back
        app.navigationBars.buttons["Meetups"].tap()
    }
    
}
