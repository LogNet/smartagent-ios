//
//  BaseRXDataSource.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class BaseRXDataSource: NSObject,UITableViewDataSource {
    let disposeBag = DisposeBag()
    var tableView: UITableView!
    var contentProvider:BaseRXContentProvider! {
        didSet{
            self.subscribeToProvider()
        }
    }
    
    // Override this function.
    internal func subscribeToProvider (){
        self.contentProvider.results.asObservable().subscribeNext { object in
            self.tableView.reloadData()
            }.addDisposableTo(self.disposeBag)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}