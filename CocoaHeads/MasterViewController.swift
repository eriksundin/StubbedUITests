//
//  MasterViewController.swift
//  CocoaHeads
//
//  Created by Erik Sundin on 01/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var events = [Event]()
    lazy var meetupClient: MeetupClient = {
        return MeetupClient(group: AppConfig.defaultMeetupGroup, baseURL: AppConfig.meetupURLString)
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meetups"
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.beginRefreshing()
        refreshControl?.addTarget(self, action: "refreshControlDidChange:", forControlEvents: .ValueChanged)
        
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if events.count == 0 {
            refreshControlDidChange(refreshControl!)
        }
    }
    
    // MARK: UIRefreshControl
    
    func refreshControlDidChange(sender: UIRefreshControl) {
        meetupClient.events { [weak self] (meetups) -> Void in
            
            self?.events = meetups
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
            
        }
    }
    
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let meetup = events[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.event = meetup
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.title = meetup.name
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let event = events[indexPath.row]
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.dateString
        return cell
    }

}

