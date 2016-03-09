//
//  EventTests.swift
//  CocoaHeads
//
//  Created by Erik Sundin on 03/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import XCTest
@testable import CocoaHeads

class EventTests: XCTestCase {
    
    func testEventCreatedFromJSON() {
        
        guard let event = Event(JSON: [
            "name" : "Test Meetup",
            "description" : "Test Description",
            "time" : 1451651820000
            ]) else {
                XCTFail("Could not create event from JSON")
                return
        }
        
        XCTAssertEqual("Test Description", event.description)
        XCTAssertEqual("2016-01-01 at 13:37", event.dateString)
        XCTAssertEqual("Test Meetup", event.name)
    }
    
}
