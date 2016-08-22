//
//  SearchViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewModel: ViewModel {
     
    let model:SearchModel
    var contentProvider:SearchContentProvider!
    
    init(model: SearchModel,router: Router) {
        self.model = model
        super.init(router: router)
    }
    
    func searchNotifications(query:String) -> Observable <[RecentNotificationCellViewModel]?> {
        return self.model.searchNotifications(query).flatMap { notifications in
            self.notificationsViewModels(notifications)
        }
    }
    
    func notificationsViewModels(notifications:[Notification]?) -> Observable<[RecentNotificationCellViewModel]?> {
        guard notifications != nil else {
            return Observable.just([])
        }
        return Observable.just(notifications!.map{RecentNotificationCellViewModel(notification: $0)})
    }
    
    func fetchSuggests(query:String) {
        guard let suggests = self.model.getSuggests(query) else {
            self.contentProvider.results.value = nil
            return
        }
        self.contentProvider.results.value = suggests.map{
            let model = SearchHistoryItem()
            model.query = $0
            return SearchHistoryCellViewModel(model: model)
        }
        print("getSuggests")
    }
    
    func fetchHistory() {
        if let queries = self.model.fetchHistory() {
            self.contentProvider.results.value = queries.map{
                SearchHistoryCellViewModel(model: $0)
            }
        }
    }
    
    func rowSelected(selectedRow:Int) -> String? {
        if let item = self.contentProvider.results.value?[selectedRow] as? SearchHistoryCellViewModel{
            self.model.saveToHistory(item.model)
            guard let query = item.model.query else {
                return nil
            }
            self.searchNotifications(query).subscribeNext {
                notificationsViewModels in
                self.contentProvider.results.value = notificationsViewModels
            }.dispose()
            
            return query
        }
        
        if let item = self.contentProvider.results.value?[selectedRow] as? RecentNotificationCellViewModel{
            self.router.showPNRDetailsFromNotification(nil)
        }
        return nil
    }

}
