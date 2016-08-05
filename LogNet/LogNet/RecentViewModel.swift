//
//  NotificatonsTVCViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseInstanceID
import RxSwift

class RecentViewModel: ViewModel {
    
    dynamic var cellViewModels:NSMutableArray?
    dynamic var loadMoreStatus:Bool = false
    dynamic var downloading:Bool = false
    dynamic var hasNextChunk:Bool = true;
    var model:SingleListNotificationModel
    var disposeBag = DisposeBag()
    
    lazy var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    init(model:SingleListNotificationModel, router:Router) {
        self.model = model
        super.init(router: router)
    
    }
    // MARK: Public Methods
    
    func selectModelForIndex(index:Int) {
        self.router.showPNRDetailsFromNotification(nil)
    }
    
    
    func fetch() {
        self.downloading = true;
        self.startFetching()
    }
    
    func fetchNext() {
        self.loadMoreStatus = true;
        self.startFetching()
      
    }
    
    func cellViewModelForRow(row:Int) -> RecentNotificationCellViewModel {
        return self.cellViewModels![row] as! RecentNotificationCellViewModel
    }
    
    //    func sendFirebaseTokenToServer() {
    //        if FIRInstanceID.instanceID().token() != nil {
    //            print("InstanceID token: \(FIRInstanceID.instanceID().token())")
    //            // Connect to FCM since connection may have failed when attempted before having a token.
    //            let serverService = GoandroidServerService()
    //            serverService.postDeviceToken(FIRInstanceID.instanceID().token()!)
    //        }
    //    }
    
    
    // MARK: Private Methods
    
    private func checkOldUser() {
        
    }
    
    private func startFetching() {
//        var viewModels:Array<RecentNotificationCellViewModel>?
        let observable = self.model.getNotifications(.Recent,fromID: 1, chunkSize: 20)
        observable.subscribeNext{ (notifications) in }.dispose()
        observable.subscribeError { (error) in
                self.downloading = false;
                switch error {
                case AppError.FORBIDDEN:
                    self.router.showLoginView()
                    break
                case AppError.NOT_ACTIVATED:
                    break
                default:
                    break
                }
            }
            .dispose()
        observable
            .subscribeCompleted {
            }.dispose()
    }
    
    
    private func viewModelFromNotification(notification:Notification) -> RecentNotificationCellViewModel {
        let viewModel = RecentNotificationCellViewModel(notification: notification)
        return viewModel
    }
}
