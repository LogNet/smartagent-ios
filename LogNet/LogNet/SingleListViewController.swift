//
//  NotificationsTableViewController.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/21/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import PKHUD
import RealmSwift
import RxSwift
import RxCocoa

let UpdateContentNotification = "UpdateContentNotification"

class SingleListViewController: UITableViewController {

    var viewModel:SingleListViewModel?
    var dataSource:AbstractDataSource?
    var token: dispatch_once_t = 0
    let disposableBag = DisposeBag()
    
    @IBOutlet var loadMoreIndicator: UIActivityIndicatorView!
    @IBOutlet var footerView: UIView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action:#selector(self.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.bindViewModel()
        self.configureDataSource()
        
        // Observe when content is updated.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(fetch), name: UpdateContentNotification, object: nil)
//        self.tabBarController?.selectedViewController?.tabBarItem.badgeValue = "3"
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.trackScreen()
        dispatch_once(&token) {
            self.fetch()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openSearchView(sender: AnyObject) {
        self.viewModel?.openSearch()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.fetch()
        refreshControl.endRefreshing()
    }

    @objc func fetch() {
        self.viewModel?.fetchInitial().subscribeError{ [weak self] error in
            error.logToCrashlytics()
            self?.showErrorAlert(error, action: nil)
            }.addDisposableTo(self.disposableBag)
    }
    
    func showNoNewMessages(){
        let nib = UINib.init(nibName: "NoMessagesView", bundle: nil)
        self.tableView.backgroundView = nib.instantiateWithOwner(self, options: nil).first as? UIView
    }
    
    // MARK: Private methods
    
    private func configureDataSource(){
        if self.dataSource != nil {
            self.dataSource?.tableView = self.tableView
            self.tableView.dataSource = dataSource
            self.dataSource?.contentProvider = self.viewModel?.contentProvider
        }
    }
    
    private func bindViewModel() {
        self.viewModel?.loadMoreStatus.asObservable().subscribeNext{ loadMore in
            if loadMore == false {
                self.loadMoreIndicator?.stopAnimating()
                self.tableView.tableFooterView = nil

            } else {
                self.tableView.tableFooterView = self.footerView
                self.loadMoreIndicator?.startAnimating()
            }
        }.addDisposableTo(self.disposableBag)
        
        self.dataSource?.noContent.asObservable()
            .subscribeNext { noContent in
                if noContent == true {
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
            self.viewModel?.fetchNext().subscribeError{ [weak self] error in
                error.logToCrashlytics()
                self?.showErrorAlert(error, action: nil)
                }.addDisposableTo(self.disposableBag)
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
            self.viewModel?.deleteNotificationForRow(indexPath.row)
        }
        delete.backgroundColor = UIColor(patternImage:UIImage(named: "delete")!)
        
        let share = UITableViewRowAction(style: .Normal, title: titleForWidth) { action, index in
            if let text = self.viewModel?.getShareTextForRow(indexPath.row) {
                self.shareText(text)
            }
        }
        share.backgroundColor = UIColor(patternImage:UIImage(named: "share")!)
        
        return [delete, share]
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UpdateContentNotification, object: nil)
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
