//
//  AppDelegate.swift
//  CocoaHeads
//
//  Created by Erik Sundin on 01/03/16.
//  Copyright © 2016 Blocket. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        #if DEBUG
            prepareForUITestsIfNeeded()
        #endif
        
        setupSplitViewController()
        return true
    }
    
    // MARK: - UITesting
    
    private func prepareForUITestsIfNeeded() {
        guard NSProcessInfo.processInfo().environment["UITests"] != nil else {
            return
        }
        
        //UIView.setAnimationsEnabled(false)
        if let stubServer = NSProcessInfo.processInfo().environment["UITestStubServer"] {
            AppConfig.meetupURLString = stubServer
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: -
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    // MARK: - Split view
    
    func setupSplitViewController() {
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.event == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

