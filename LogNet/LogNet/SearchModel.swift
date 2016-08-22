//
//  SearchMolde.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchModel {
    var storageService: NotificationsStorageServise!
    var searchHistoryStorage: SearchHistoryStorage!

    
    func searchNotifications(query:String) -> Observable<[Notification]?> {
        assert(self.storageService != nil, "StorageService is nil")
        return Observable.create { observer in
            do {
                let notifications = try self.storageService.search(query)
                observer.onNext(notifications)
                observer.onCompleted()
            } catch let error as NSError {
                observer.onError(error)
            }
            return AnonymousDisposable {}
        }
    }
    
    func getSuggests(query:String) -> [String]? {
        assert(self.storageService != nil, "StorageService is nil")
        do {
            let suggests = try self.storageService.getSuggestTitles(query)
            return suggests
        } catch _ as NSError {
            return nil
        }
    }
    
    func saveToHistory(searchItem:SearchHistoryItem) {
        self.searchHistoryStorage.addSearchHistoryItem(searchItem, completion: nil)
    }
    
    func fetchHistory() -> [SearchHistoryItem]? {
        return self.searchHistoryStorage.fetchHistoryItems()
    }
}
