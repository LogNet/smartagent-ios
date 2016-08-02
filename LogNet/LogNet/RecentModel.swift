//
//  NotificationsModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift

class RecentModel: NSObject {
    var apiFacade:APIFacade?
    var serverParser:ServerParser?
    var storageService: NotificationsStorageServise?
    
    // MARK: Public methods
    
    func getNotifications(fromID:Int?, chunkSize:Int8) -> Observable<Any> {
        return Observable.create({observer in
            self.apiFacade?.getRecentNotifications(fromID, chunkSize: 20, completion: { [weak self] (JSON:AnyObject?, error:NSError?) in
                if error == nil {
                    if JSON != nil {
                        let notifications = self?.serverParser?.parseNotifications(JSON)
                        print("notifications: \(notifications)")
                        let error1 = NSError(domain: "error", code: 403, userInfo: nil)
                        observer.onError(error1)
//                        observer.onNext(notifications)
//                        observer.onCompleted()
//                        completion(error: error, notifications: notifications)
                    } else {
                        observer.onError(error!)
//                        completion(error: error, notifications: nil)
                    }
                } else {
                    observer.onError(error!)
                }
            })
            return AnonymousDisposable {}
        })
    }
    
    
    
}
