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
        self.router.showPNRDetailsFromNotification(nil)
    }
    
    func fetchInitial() {
        if self.downloading { return }
        self.downloading = true;
        self.startFetching(0)
    }
    
    func fetchNext() {
        if self.loadMoreStatus.value.boolValue || self.downloading { return }
        self.loadMoreStatus.value = true;
        self.startFetching((self.contentProvider?.notifications.count)!/self.model.chunkSize)
    }
    
    // MARK: Private Methods
    
    private func startFetching(offset:Int) {
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
                    break
                }
            }, onCompleted: {
                
            }, onDisposed: {
                
        }).addDisposableTo(self.disposeBag)
        
    }
    
}