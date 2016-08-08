//
//  NotificationsTableViewController.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/21/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
//import ReactiveCocoa
import PKHUD
import RealmSwift
import RxSwift
import RxCocoa


class RecentViewController: UITableViewController {

    var viewModel:RecentViewModel?
    var token: dispatch_once_t = 0
    var notificationToken: NotificationToken? = nil
    let disposableBag = DisposeBag()
    
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
        self.subscribeToRealm()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_once(&token) {
            self.viewModel?.fetch()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func subscribeToRealm() {
        // Observe Results Notifications
        notificationToken = self.viewModel?.notifications.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .Initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .Update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                tableView.endUpdates()
                break
            case .Error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if self.viewModel?.cellViewModels != nil {
//            return (self.viewModel?.cellViewModels!.count)!
//        }
        return self.viewModel?.notifications.count ?? 0
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
        
        Observable.just(self.viewModel?.loadMoreStatus).subscribeNext{ loadMore in
            if loadMore == false {
                self.loadMoreIndicator.stopAnimating()
            } else {
                self.tableView.tableFooterView = self.footerView
                self.loadMoreIndicator.startAnimating()
            }
        }.addDisposableTo(self.disposableBag)
        
        Observable.just(self.viewModel?.notifications)
            .subscribeNext { notifications in
                if notifications == nil {
                    self.showNoNewMessages()
                } else {
                    if self.tableView.backgroundView != nil {
                        self.tableView.backgroundView = nil
                    }
                }
        }.addDisposableTo(self.disposableBag)
        
        Observable.just(self.viewModel?.downloading).subscribeNext{ downloading in
            if downloading == true {
                HUD.show(.Progress)
            } else if HUD.isVisible {
                HUD.flash(.Progress)
            }
        }.addDisposableTo(self.disposableBag)
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
        self.viewModel?.selectModelForIndex(indexPath.row)
        
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

    deinit {
        notificationToken?.stop()
    }
    
}
