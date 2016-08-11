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
    dynamic var cellViewModels:NSMutableArray?
    dynamic var loadMoreStatus:Bool = false
    dynamic var downloading:Bool = false
    dynamic var hasNextChunk:Bool = true;
    var model:SingleListNotificationModel
    var contentProvider:AbstractContentProvider?
    let listType:ListType
    
    private var disposeBag = DisposeBag()
    
    lazy var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    // Class cluster methods
    
    class func recentViewModel(model:SingleListNotificationModel, router:Router) -> SingleListViewModel {
        let viewModel = SingleListViewModel(model: model, router: router, listType: .Recent)
        return viewModel
    }
    
    class func ticketingDueViewModel(model:SingleListNotificationModel, router:Router) -> SingleListViewModel {
        let viewModel = SingleListViewModel(model: model, router: router, listType: .TicketingDue)
        return viewModel
    }
    
    // Init
    
    init(model:SingleListNotificationModel, router:Router, listType:ListType) {
        self.model = model
        self.listType = listType
        self.contentProvider = AbstractContentProvider(listType: listType)
        super.init(router: router)
        
    }
    
    // MARK: Public Methods
    
    func selectModelForIndex(index:Int) {
        self.router.showPNRDetailsFromNotification(nil)
    }
    
    
    func fetch() {
        if self.downloading { return }
        self.downloading = true;
        self.startFetching()
    }
    
    func fetchNext() {
        if self.loadMoreStatus { return }
        self.loadMoreStatus = true;
        self.startFetching()
        
    }
    
    // MARK: Private Methods
    
    private func startFetching() {
        _ = self.model.fetchNotifications(self.listType,subtype: .All, offset: 0, chunkSize: 20).subscribe(onNext: { notifications in
            self.downloading = false;
            self.loadMoreStatus = false;
            }, onError:{ error in
                self.downloading = false;
                switch error {
                case ApplicationError.FORBIDDEN:
                    self.router.showLoginView()
                    break
                case ApplicationError.NOT_ACTIVATED:
                    self.router.showNoActivatedView()
                    break
                default:
                    break
                }
            }, onCompleted: {
                
            }, onDisposed: {
                
        }).addDisposableTo(self.disposeBag)
        
    }
    
}