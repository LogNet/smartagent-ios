//
//  PNRDataSource.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PNRDataSource: BaseRXDataSource {
    
    override func subscribeToProvider (){
        super.subscribeToProvider()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "STATUS"
        case 0:
            return "PNR DATA"
        case 0:
            return "PASSENGERS"
        case 0:
            return "FLIGHT"
        case 0:
            return "HOTEL"
        case 0:
            return "CAR RENTAL"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contentProvider.results.value?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let result = self.contentProvider.results.value![indexPath.row]
        
        if let viewModel = result as? StatusCellViewModel {
            
        } else if let viewModel = result as? PNRCellViewModel {
            
        } else if let viewModel = result as? PNRCellViewModel {
            
        } else if let viewModel = result as? PNRCellViewModel {
            
        } else if let viewModel = result as? PNRCellViewModel {
            
        } else if let viewModel = result as? PNRCellViewModel {
            
        }
        
        return cell
    }
}