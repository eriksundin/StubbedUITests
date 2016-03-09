//
//  Meetup.swift
//  CocoaHeads
//
//  Created by Erik Sundin on 01/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import Foundation

class Event {
    
    private(set) var name: String?
    private(set) var description: String?
    private var time: Int?
    
    private static let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        return df
    }()
    
    var dateString: String? {
        guard let time = time else {
            return "N/A"
        }
        let date = NSDate(timeIntervalSince1970: Double(time) / 1000.0)
        return Event.dateFormatter.stringFromDate(date)
    }
    
    init?(JSON: AnyObject) {
        guard let JSON = JSON as? [String : AnyObject] else {
            return nil
        }
        
        name = JSON["name"] as! String?
        description = JSON["description"] as! String?
        time = JSON["time"] as! Int?
        
    }
    
}