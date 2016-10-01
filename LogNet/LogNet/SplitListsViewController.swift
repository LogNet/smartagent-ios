//
//  RepriceViewController.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class SplitListsViewController: UIViewController {
    
    //TODO: Needs refactoring
    var pendingViewModel:SingleListViewModel!
    var completedViewModel:SingleListViewModel!
    var pendingDataSource:AbstractDataSource!
    var completedDataSource:AbstractDataSource!
    var listType:ListType!
    //TODO: Needs refactoring
    var router:Router!

    var containerViewController:ContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Analytics.
        AppAnalytics.logEvent(self.listType == ListType.Reprice ? Events.SCREEN_REPRICE_LIST : Events.SCREEN_CANCELLED_LIST)
    }

    // MARK: - IBActions

    @IBAction func openSearchView(sender: AnyObject) {
        self.router.showSearchView()
    }
    
    @IBAction func switchTableView(sender: AnyObject) {
        self.containerViewController.switchViewControllers()
    }
    
    // MARK: - Methods


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "embededContainer" {
            self.containerViewController = segue.destinationViewController as! ContainerViewController
            
            //TODO: Needs refactoring
            self.containerViewController.pendingViewModel = self.pendingViewModel
            self.containerViewController.pendingDataSource = self.pendingDataSource
            self.containerViewController.completedViewModel = self.completedViewModel
            self.containerViewController.completedDataSource = self.completedDataSource

        }
    }

}
