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
        self.contentProvider.results = Variable([SearchHistoryCellViewModel(suggestTitle: "Hello"),SearchHistoryCellViewModel(suggestTitle: "Query")])
        
    }
    
    func fetchHistory() {
        self.contentProvider.results = Variable([SearchHistoryCellViewModel(suggestTitle: "Hello"),SearchHistoryCellViewModel(suggestTitle: "Query")])
    }
    
    func saveToHistory(selectedIndex:Int) {
        if let item = self.contentProvider.results.value?[selectedIndex] as? SearchHistoryItem{
            self.model.saveToHistory(item)
        }
    }

}
