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

class NotificatonsViewModel: ViewModel {
    dynamic var cellViewModels:NSMutableArray?
    dynamic var downloading = false
    var model:NotificationsModel
    
    lazy var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    init(model:NotificationsModel, router:Router) {
        self.model = model
        super.init(router: router)
    }
    
    func checkUserLoggedIn() {
        let serverService = GoandroidServerService()
        if serverService.getToken() == nil {
            self.router.showLoginView()
        } else {
            self.fetch()
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
        var viewModels = Array<NotificationCellViewModel>()
        weak var weakSelf = self
        self.model.getNotifications { (error, notifications) in
            if notifications != nil {
                for notification in notifications! {
                    if let viewModel = weakSelf?.viewModelFromNotification(notification){
                        viewModels.append(viewModel)
                    }
                }
            }
            self.downloading = false;
            self.cellViewModels = NSMutableArray(array: viewModels)
        }
    }
    
    func viewModelFromNotification(notification:Notification) -> NotificationCellViewModel {
        let viewModel = NotificationCellViewModel()
        viewModel.text = notification.text
        viewModel.title = notification.title
        viewModel.link = notification.link
        viewModel.date = self.dateFormatter.stringFromDate(notification.time!)
        return viewModel
    }
    
    func cellViewModelForRow(row:Int) -> NotificationCellViewModel {
        return self.cellViewModels![row] as! NotificationCellViewModel
    }
    
}
