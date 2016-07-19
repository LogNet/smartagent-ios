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

class RecentViewModel: ViewModel {
    
    dynamic var cellViewModels:NSMutableArray?
    dynamic var loadMoreStatus:Bool = false
    dynamic var downloading:Bool = false
    dynamic var hasNextChunk:Bool = true;
    var model:RecentModel
    
    lazy var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    // MARK: Methods
    
    init(model:RecentModel, router:Router) {
        self.model = model
        super.init(router: router)
    }
    
    func checkUserLoggedIn() {
        let loginService = SmartAgentLoginServise()
        if loginService.isAutorized() {
            self.fetch()
        } else {
            self.router.showLoginView()
        }
    }
    
    private func checkOldUser() {
            }
    
    // MARK: Push Notifications
    
//    func sendFirebaseTokenToServer() {
//        if FIRInstanceID.instanceID().token() != nil {
//            print("InstanceID token: \(FIRInstanceID.instanceID().token())")
//            // Connect to FCM since connection may have failed when attempted before having a token.
//            let serverService = GoandroidServerService()
//            serverService.postDeviceToken(FIRInstanceID.instanceID().token()!)
//        }
//    }
    
    func fetch() {
        self.downloading = true;
        self.startFetching()
    }
    
    func fetchNext() {
        self.loadMoreStatus = true;
        self.startFetching()
      
    }
    
    func startFetching() {
        var viewModels:Array<RecentNotificationCellViewModel>?
//        if let model = self.cellViewModels.lastObject as? RecentNotificationCellViewModel {
            self.model.getNotifications(1, chunkSize: 20) { [weak self] (error, notifications) in
                if notifications != nil {
                    viewModels = Array<RecentNotificationCellViewModel>()
                    for notification in notifications! {
                        if let viewModel = self?.viewModelFromNotification(notification){
                            viewModels!.append(viewModel)
                        }
                    }
                    self?.cellViewModels = NSMutableArray(array: viewModels!)
                }
                self?.downloading = false;
                self?.loadMoreStatus = false;
//            }

        }
    }
    
    func viewModelFromNotification(notification:Notification) -> RecentNotificationCellViewModel {
        let viewModel = RecentNotificationCellViewModel(notification: notification)
        return viewModel
    }
    
    func cellViewModelForRow(row:Int) -> RecentNotificationCellViewModel {
        return self.cellViewModels![row] as! RecentNotificationCellViewModel
    }
    
}
