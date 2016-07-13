//
//  NotificationsModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class RecentModel: NSObject {
    var apiFacade:APIFacade?
    var serverParser:ServerParser?
    var storageService: NotificationsStorageServise?
    
    // MARK: Public methods
    
    func getNotifications(fromID:Int?, chunkSize:Int8, completion:((error:NSError?, notifications:Array<Notification>?)->Void)) {
        self.apiFacade?.getRecentNotifications(fromID, chunkSize: 20, completion: { [weak self] (JSON:AnyObject?, error:NSError?) in
            if error == nil {
                if JSON != nil {
                    let notifications = self?.serverParser?.parseNotifications(JSON)
                    print("notifications: \(notifications)")
                    completion(error: error, notifications: notifications)
                } else {
                    completion(error: error, notifications: nil)
                }
            } else {
                completion(error: error, notifications: nil)
            }
        })
    }
    
    
    
}
