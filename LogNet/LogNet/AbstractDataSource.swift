//
//  DataSource.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class AbstractDataSource: NSObject, UITableViewDataSource {
    
    var contentProvider: AbstractContentProvider?
    var tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        
        return cell
    }

    
}
