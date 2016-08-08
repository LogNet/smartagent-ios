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
import RealmSwift
import Realm

class RecentViewModel: ViewModel {
    
    dynamic var cellViewModels:NSMutableArray?
    dynamic var loadMoreStatus:Bool = false
    dynamic var downloading:Bool = false
    dynamic var hasNextChunk:Bool = true;
    var model:SingleListNotificationModel
    
    private var disposeBag = DisposeBag()
    private let realm = try! Realm()
    private var results:Results<Notification>?
    
    lazy var notifications:Results<Notification> = {
        let results = self.realm.objects(Notification.self).filter("listType = '\(ListType.Recent.rawValue)'")
        return results
    }()
    
    lazy var dateFormatter:NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        return formatter
    }()
    
    init(model:SingleListNotificationModel, router:Router) {
        self.model = model
        super.init(router: router)
    
    }
    
//    func fetchFromDatabase() {
//        let realm = try! Realm()
//        let results = realm.objects(Notification.self).filter("listType == \()")
//    }
    
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
    
    func cellViewModelForRow(row:Int) -> RecentNotificationCellViewModel {
        let notification = notifications[row]
        return self.viewModelFromNotification(notification)
//        return self.cellViewModels![row] as! RecentNotificationCellViewModel
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
        _ = self.model.fetchNotifications(.Recent,subtype: .All, offset: 0, chunkSize: 20).subscribe(onNext: { notifications in
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
    
    
    private func viewModelFromNotification(notification:Notification) -> RecentNotificationCellViewModel {
        let viewModel = RecentNotificationCellViewModel(notification: notification)
        return viewModel
    }
}
