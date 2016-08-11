//
//  RecentDataSource.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/11/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit

class RecentDataSource: AbstractDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentNotificationCell", forIndexPath: indexPath) as! RecentNotificationCell
        if let viewModel = self.contentProvider?.cellViewModelForRow(indexPath.row) {
            cell.setViewModel(viewModel)
        }
        // Configure the cell...
        
        return cell
    }

}