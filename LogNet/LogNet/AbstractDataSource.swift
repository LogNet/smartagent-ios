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

class AbstractDataSource: NSObject, UITableViewDataSource {
    
    var tableView: UITableView?
    var contentProvider: AbstractContentProvider? {
        didSet{
            self.subscribeToRealm()
        }
    }
    private var notificationToken: NotificationToken? = nil

    private func subscribeToRealm() {
        // Observe Results Notifications
        self.notificationToken = self.contentProvider?.notifications.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
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
