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
    
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action:#selector(self.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.bindViewModel()
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
            return (self.viewModel?.cellViewModels!.count)!
        }
        return 0
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.fetch()
        refreshControl.endRefreshing()
    }

    func fetch() {
        self.viewModel?.fetch()
    }
    
    func showNoNewMessages(){
        let nib = UINib.init(nibName: "NoMessagesView", bundle: nil)
        self.tableView.backgroundView = nib.instantiateWithOwner(self, options: nil).first as? UIView
    }
    
    // MARK: Private methods
    
    func bindViewModel() {
        
        self.viewModel?.rac_valuesForKeyPath("loadMoreStatus", observer: self).subscribeNext({loadMoreStatus in
            if loadMoreStatus.boolValue == false {
                self.loadMoreIndicator.stopAnimating()
//                self.tableView.tableFooterView = nil
            } else {
                self.tableView.tableFooterView = self.footerView
                self.loadMoreIndicator.startAnimating()
            }

        })
        
        self.viewModel?.rac_valuesForKeyPath("cellViewModels", observer: self).subscribeNext({[weak self] (models:AnyObject!) in
            if models == nil {
                self?.showNoNewMessages()
            } else {
                if self?.tableView.backgroundView != nil {
                    self?.tableView.backgroundView = nil
                }
                self!.tableView.reloadData()

            }
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentNotificationCell", forIndexPath: indexPath) as! RecentNotificationCell
        if let viewModel = self.viewModel?.cellViewModelForRow(indexPath.row) {
            cell.setViewModel(viewModel)
        }
        // Configure the cell...
        

        return cell
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewModel = self.viewModel?.cellViewModelForRow(indexPath.row)
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 && self.viewModel?.hasNextChunk == true {
//            self.viewModel?.fetchNext()
        }
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let titleForWidth = "         "
        let delete = UITableViewRowAction(style: .Default, title:titleForWidth) { action, index in
            print("more button tapped")
        }
        delete.backgroundColor = UIColor(patternImage:UIImage(named: "delete")!)
        
        let share = UITableViewRowAction(style: .Normal, title: titleForWidth) { action, index in
            print("favorite button tapped")
        }
        share.backgroundColor = UIColor(patternImage:UIImage(named: "share")!)
        
        return [delete, share]
    }
    

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
