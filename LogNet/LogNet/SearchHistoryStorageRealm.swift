//
//  SearchHistoryStorageRealm.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class SearchHistoryStorageRealm: RealmStorage, SearchHistoryStorage {
    
    override init() {
        super.init()
        self.saveQueue = dispatch_queue_create("com.lognet.searchhistory.queue", DISPATCH_QUEUE_SERIAL)
    }
    
    func addSearchHistoryItem(item: SearchHistoryItem, completion: ErrorCompletionBlock?) {
        self.addObject(item, completion: completion)
    }
    
    func fetchHistoryItems() -> [SearchHistoryItem]? {
        let realm = try! Realm()
        return Array(realm.objects(SearchHistoryItem.self))
    }
}