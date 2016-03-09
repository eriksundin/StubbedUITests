//
//  CocoaHeadsUITests.swift
//  CocoaHeadsUITests
//
//  Created by Erik Sundin on 01/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import XCTest
import Swifter

// Create a JSON object from a file in the test bundle
func objectForBundledJson(name: String) -> AnyObject {
    let bundle = NSBundle(forClass: CocoaHeadsUITests.self)
    let url = bundle.URLForResource(name, withExtension: ".json")
    let object = try! NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: url!)!, options: NSJSONReadingOptions.AllowFragments)
    return object
}

/**
 * This test will launch an HTTP server for the duration of the test, stubbing requests made by the app.
 */
class CocoaHeadsUITests: XCTestCase {
    
    let server = HttpServer()
    
    override func setUp() {
        super.setUp()
        
        // Respond with the contents of events.json
        let object = objectForBundledJson("events")
        server["/2/events"] = { (request) in .OK(.Json(object)) }
        
        // Start the server
        try! server.start(8080)
        
        continueAfterFailure = false
        
        // Start the app and pass environment
        let app = XCUIApplication()
        app.launchEnvironment = [
            "UITests" : "true",
            "UITestStubServer" : "http://localhost:8080"
        ]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Stop the server
        server.stop()
    }
    
    func testBrowseMeetup() {
        
        let app = XCUIApplication()
        
        // Assert title
        XCTAssert(app.staticTexts["Meetups"].exists)
        
        // Wait until the first cell exists
        let meetupCell = app.tables.staticTexts["Test Meetup"]
        expectationForPredicate(NSPredicate(format: "exists == true"), evaluatedWithObject: meetupCell, handler: nil)
        waitForExpectationsWithTimeout(3.0, handler: nil)
        
        // Assert contents in the list
        XCTAssertTrue(app.tables.staticTexts["Test Meetup"].exists)
        XCTAssertTrue(app.tables.staticTexts["2016-01-01 at 13:37"].exists)
        
        // Go into details
        app.tables.staticTexts["Test Meetup"].tap()
        
        // Assert title
        XCTAssert(app.staticTexts["Test Meetup"].exists)
        
        // Go Back
        app.navigationBars.buttons["Meetups"].tap()
    }
    
}
