//
//  SearchHistoryItem.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class SearchHistoryItem: Object {
    dynamic var query: String?
    dynamic var date: NSDate?
    
    override static func primaryKey() -> String? {
        return "query"
    }
}