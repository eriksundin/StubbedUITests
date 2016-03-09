//
//  MeetupClient.swift
//  CocoaHeads
//
//  Created by Erik Sundin on 01/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import Foundation
import Alamofire

class MeetupClient {
    
    var group: String
    var baseURL: String
    
    init(group: String, baseURL: String) {
        self.group = group
        self.baseURL = baseURL
    }
    
    func events(completion: (meetups: [Event]) -> Void) {

        let parameters = [
            "photo-host" : "public",
            "group_urlname" : group,
            "status" : "upcoming,past",
            "page" : "20",
            "desc" : "desc",
        ]
        
        Alamofire.request(.GET, baseURL + "/2/events", parameters: parameters)
            .responseJSON { response in
                
                var events = [Event]()
                if let JSON = response.result.value as? [String: AnyObject] {
                    
                    for eventData in JSON["results"] as! [[String: AnyObject]] {
                        
                        if let event = Event(JSON: eventData) {
                            events.append(event)
                        }
                    }
                }
                
                completion(meetups: events)
        }
}
    
}