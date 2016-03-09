//
//  MeetupClientTests.swift
//  MeetupClientTests
//
//  Created by Erik Sundin on 01/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import CocoaHeads

class MeetupClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testFetchEvents() {
    
        // Stub the request
        let stub = OHHTTPStubs.stubRequestsPassingTest({ (request) -> Bool in
            return request.URL!.path!.containsString("/2/events")
            }) { (request) -> OHHTTPStubsResponse in
                let json = OHPathForFile("events.json", self.dynamicType)
                return OHHTTPStubsResponse(fileAtPath: json!, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
    
        // Setup an expectation
        let expectation = expectationWithDescription("request")
        
        // Execute request to get events
        let client = MeetupClient(group: "some group", baseURL: "https://www.test.com")
        var events = [Event]()
        client.events { (meetups) -> Void in
            events = meetups
            expectation.fulfill()
        }
        
        // Wait until it finishes
        waitForExpectationsWithTimeout(5.0, handler: nil)
        
        // Assert that we got one event back
        XCTAssertEqual(events.count, 1)
        
        OHHTTPStubs.removeStub(stub)
    }
    
}
