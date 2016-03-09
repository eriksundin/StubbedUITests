//
//  DetailViewController.swift
//  CocoaHeads
//
//  Created by Erik Sundin on 01/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var event: Event?
    @IBOutlet var webView: UIWebView!

    func configureView() {
        // Update the user interface for the detail item.
        if let event = event {
            title = event.name
            if let description = event.description {
                webView.loadHTMLString("<html><body>" + description + "</body></html>", baseURL: nil)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
}
