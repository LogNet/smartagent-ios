//
//  NotificationsModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class NotificationsModel: NSObject {
    
    var servserService:ServerService?
    var serverParser:ServerParser?
    var storageService: NotificationsStorageServise?
    
    // MARK: Public methods
    
    func getNotifications(completion:((error:NSError?, notifications:Array<Notification>?)->Void)) {
        if self.servserService != nil {
            weak var weakSelf = self
            self.servserService?.getNotifications({ (JSON:AnyObject?, error:NSError?) in
                if JSON != nil || error == nil {
                    let notifications = weakSelf?.serverParser?.parseNotifications(JSON)
                    print("notifications: \(notifications)")
                } else {
                    completion(error: error, notifications: nil)
                }
            })
        }
    }
    
}
