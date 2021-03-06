//
//  DataSource.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class AbstractDataSource:NSObject, UITableViewDataSource {
    
    var tableView: UITableView!
    let noContent = Variable(false)
    var contentProvider: AbstractContentProvider! {
        didSet{
            self.subscribeToRealm()
        }
    }
    private var notificationToken: NotificationToken? = nil

    private func subscribeToRealm() {
        // Observe Results Notifications
        self.notificationToken = self.contentProvider.notifications.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.noContent.value = self?.contentProvider.notifications.count <= 0
            switch changes {
            case .Initial:
                // Results are now populated and can be accessed without blocking the UI
                self!.tableView.reloadData()
                break
            case .Update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.tableView.beginUpdates()
                self!.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self!.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self!.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self!.tableView.endUpdates()
                break
            case .Error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contentProvider?.notifications.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        
        return cell
    }

    deinit {
        self.notificationToken?.stop()
    }
    
}
