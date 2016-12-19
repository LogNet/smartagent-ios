//
//  RepricePNRView.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class PNRInfoViewController: UITableViewController {

    @IBOutlet weak var showStatusPrices: UIButton!
    let disposeBag = DisposeBag()
    var viewModel:PNRInfoViewModel!
    var dataSource: PNRDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self.dataSource
        self.dataSource.tableView = self.tableView
        self.dataSource.contentProvider = self.viewModel.contentProvider
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(self.openActionSheet))
        self.navigationItem.rightBarButtonItem = item
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        HUD.show(.SystemActivity)
        self.viewModel.fetchPNRInfo().subscribe(onNext: {
                HUD.hide()
            },
            onError: { error in
                HUD.hide()
                error.logToCrashlytics()
                self.showErrorAlert(error, action: { (UIAlertAction) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
            },
            onCompleted: {
            },
            onDisposed: {
        }).addDisposableTo(self.disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    private func removeOperation() {
        HUD.show(.SystemActivity)
        self.viewModel.remove().subscribe(onNext: { Void in
            HUD.hide(animated: true)
            }, onError: { error in
                error.logToCrashlytics()
                HUD.hide(animated: true)
                self.showErrorAlert(error, action: nil)
            }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(self.disposeBag)
    }
    
    private func showApproveRepriceAlert() {
        let alert = UIAlertController(title: "Please, approve reprice", message: "Please notice that this PNR is ticketed. Press OK to perform reprice or cancel to abort.", preferredStyle: .Alert)
        let repriceAction = UIAlertAction(title: "OK", style: .Default) { [weak self] (action) in
            self?.reprice()
        }
        alert.addAction(repriceAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func reprice() {
        HUD.show(.SystemActivity)
        self.viewModel.reprice().subscribe(onNext: { Void in
            HUD.hide(animated: true)
            }, onError: { error in
                error.logToCrashlytics()
                HUD.hide(animated: true)
                self.showErrorAlert(error, action: nil)
            }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(self.disposeBag)
    }
    
    private func share() {
        guard let text = self.viewModel.getShareText() else {
            return
        }
        AppAnalytics.logEvent(Events.ACTION_SHARE)
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: [RepriceActivity()])
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func executePendingOperation(sender: AnyObject) {
        let switchControl = sender as! UISwitch
        switchControl.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.viewModel.keepRepricing().subscribe(onNext: { Void in
            self.navigationItem.rightBarButtonItem?.enabled = true
            }, onError: { error in
                error.logToCrashlytics()
                self.navigationItem.rightBarButtonItem?.enabled = true
                self.showErrorAlert(error, action: nil)
            }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(self.disposeBag)
    }
    
    @IBAction func makeACall(sender: AnyObject) {
            self.viewModel.callToContact()
    }
    
    @objc func openActionSheet () {
        let actionSheet = UIAlertController(title: "Choose an action", message:nil, preferredStyle: .ActionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .Default) { [weak self] (action) in
            self?.share()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        // Add action button.
        if self.viewModel.type == "RP" {
            let repriceAction = UIAlertAction(title: "Approve reprice", style: .Default) { [weak self] (action) in
                if self?.viewModel.isTicketed == true {
                    self?.showApproveRepriceAlert()
                } else {
                    self?.reprice()
                }
            }
            repriceAction.enabled = self.viewModel.activeActionEnabled
            actionSheet.addAction(repriceAction)
            
        } else if self.viewModel.type == "C" {
            let repriceAction = UIAlertAction(title: "Remove", style: .Default) { [weak self] (action) in
                self?.removeOperation()
            }
            repriceAction.enabled = true
            actionSheet.addAction(repriceAction)
        }
        actionSheet.addAction(shareAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return 5
        }
        return 1
    }

//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
////        if indexPath.section == 0  && self.statusPriceOpened.value.boolValue == true{
////            return 130;
////        } else if indexPath.section == 0 {
////            return 90;
////        } else {
////            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
////        }
//    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
