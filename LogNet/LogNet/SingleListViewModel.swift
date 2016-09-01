//
//  SingleListViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/10/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseInstanceID
import RxSwift
import RealmSwift
import Realm

class SingleListViewModel: ViewModel {
    var loadMoreStatus = Variable(false)
    dynamic var downloading:Bool = false
    dynamic var hasNextChunk:Bool = false;
    var contentProvider:AbstractContentProvider?
    
    private var model:SingleListNotificationModel
    private let listType:ListType
    private let subtype: NotificationSubtype
    private let chunkSize = 20;
    private var disposeBag = DisposeBag()
    
    // Class cluster methods
    
    class func recentViewModel(model:SingleListNotificationModel, router:Router) -> SingleListViewModel {
        let viewModel = SingleListViewModel(model: model, router: router, listType: .Recent, subtype: .All)
        return viewModel
    }
    
    class func ticketingDueViewModel(model:SingleListNotificationModel, router:Router) -> SingleListViewModel {
        let viewModel = SingleListViewModel(model: model, router: router, listType: .TicketingDue, subtype: .All)
        return viewModel
    }
    
    class func repriceViewModel(model:SingleListNotificationModel,subtype: NotificationSubtype, router:Router) -> SingleListViewModel {
        let viewModel = SingleListViewModel(model: model, router: router, listType: .Reprice, subtype: subtype)
        return viewModel
    }
    
    class func cancelledViewModel(model:SingleListNotificationModel,subtype: NotificationSubtype, router:Router) -> SingleListViewModel {
        let viewModel = SingleListViewModel(model: model, router: router, listType: .Cancelled, subtype: subtype)
        return viewModel
    }
    
    // Init
    
    init(model:SingleListNotificationModel, router:Router, listType:ListType, subtype: NotificationSubtype) {
        self.model = model
        self.listType = listType
        self.contentProvider = AbstractContentProvider(listType: listType, subtype: subtype)
        self.subtype = subtype
        super.init(router: router)
        
    }
    
    // MARK: Public Methods
    
    func openSearch() {
        self.router.showSearchView()
    }
    
    func selectModelForIndex(index:Int) {
        if let notification = self.contentProvider?.notifications[index] {
            self.router.showPNRDetailsFromNotification(notification)
        }
    }
    
    func fetchInitial() -> Observable<Void> {
        if self.downloading { return Observable.just() }
        self.downloading = true;
        return self.startFetching(0)
    }
    
    func fetchNext() -> Observable<Void> {
        if self.loadMoreStatus.value.boolValue || self.downloading { return Observable.just() }
        self.loadMoreStatus.value = true;
        return self.startFetching((self.contentProvider?.notifications.count)!/self.model.chunkSize)
    }
    
    func deleteNotificationForRow(row:Int){
        if let notification = self.contentProvider?.notifications[row] {
           self.model.deleteNotification(notification).subscribeNext{
            
           }.addDisposableTo(self.disposeBag)
        }
    }
    
    // MARK: Private Methods
    
    private func startFetching(offset:Int) -> Observable<Void> {
        return Observable.create { observer in
            _ = self.model.fetchNotifications(self.listType,subtype: self.subtype, offset: offset).subscribe(onNext: { [weak self] hasNextChunk in
                self!.hasNextChunk = hasNextChunk
                self!.downloading = false;
                self!.loadMoreStatus.value = false;
                }, onError:{ [weak self] error in
                    self!.downloading = false;
                    switch error {
                    case ApplicationError.FORBIDDEN:
                        self!.router.showLoginView()
                        break
                    case ApplicationError.NOT_ACTIVATED:
                        self!.router.showNoActivatedView()
                        break
                    default:
                        observer.onError(error)
                        break
                    }
                }, onCompleted: {
                    
                }, onDisposed: {
                    
            }).addDisposableTo(self.disposeBag)
            
            return AnonymousDisposable{}
        }
        
    }
    
}