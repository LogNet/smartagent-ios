//
//  NotificationsTableViewController.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/21/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import ReactiveCocoa
import PKHUD

class RecentViewController: UITableViewController {

    var viewModel:RecentViewModel?
    var token: dispatch_once_t = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action:#selector(self.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        weak var weakSelf = self
        self.viewModel?.rac_valuesForKeyPath("cellViewModels", observer: self).subscribeNext({ (string:AnyObject!) in
            weakSelf?.tableView.reloadData()
        })
        
        let signal = self.viewModel?.rac_valuesForKeyPath("downloading", observer: self)
        signal?.subscribeNext({x in
            if x.boolValue == true {
                HUD.show(.Progress)
            } else if HUD.isVisible {
                HUD.flash(.Progress)
            }
        })
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_once(&token) {
            self.viewModel?.checkUserLoggedIn()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.viewModel?.cellViewModels != nil {
            return (self.viewModel?.cellViewModels?.count)!
        }
        return 1
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.fetch()
        refreshControl.endRefreshing()
    }

    func fetch() {
        self.viewModel?.fetch()
    }
    
    // MARK: Private methods

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard ((self.viewModel?.cellViewModels) != nil) else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NothingCell")
            return cell!
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! NotificationCell
        let viewModel = self.viewModel?.cellViewModelForRow(indexPath.row)
        // Configure the cell...
        cell.title.text = viewModel?.title
        cell.body.text = viewModel?.text
        cell.date.text = viewModel?.date

        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewModel = self.viewModel?.cellViewModelForRow(indexPath.row)
        self.viewModel?.router.openURLString((viewModel?.link)!)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
