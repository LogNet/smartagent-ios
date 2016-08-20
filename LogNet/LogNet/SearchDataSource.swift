//
//  SearchHistoryDataSource.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchHistoryDataSource: NSObject,UITableViewDataSource{
    let disposeBag = DisposeBag()
    
    var contentProvider:SearchContentProvider! {
        didSet{
            self.subscribeToProvider()
        }
    }
    var tableView: UITableView!

    // MARK: Private
    
    private func subscribeToProvider (){
        self.contentProvider.results.asObservable().subscribeNext { object in
            self.tableView.reloadData()
        }.addDisposableTo(self.disposeBag)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contentProvider.results.value?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let result = self.contentProvider.results.value![indexPath.row]
        
        if result is SearchHistoryCellViewModel {
            let historyCell = tableView.dequeueReusableCellWithIdentifier("SearchHistoryCell", forIndexPath: indexPath) as! SearchHistoryCell
            historyCell.setViewModel(result as! SearchHistoryCellViewModel)
            cell = historyCell
            
        } else if result is RecentNotificationCellViewModel {
            let recentCell = tableView.dequeueReusableCellWithIdentifier("RecentNotificationCell", forIndexPath: indexPath) as! RecentNotificationCell
            recentCell.setViewModel(result as! RecentNotificationCellViewModel)
            cell = recentCell
            
        } else {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        
        return cell
    }

}