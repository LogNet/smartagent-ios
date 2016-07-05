//
//  NotificationsModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class RecentModel: NSObject {
    
    var servserService:ServerService?
    var serverParser:ServerParser?
    var storageService: NotificationsStorageServise?
    
    // MARK: Public methods
    
    func getNotifications(completion:((error:NSError?, notifications:Array<Notification>?)->Void)) {
        if self.servserService != nil {
            weak var weakSelf = self
            self.servserService?.getNotifications({ (JSON:AnyObject?, error:NSError?) in
                if JSON != nil || error == nil {
                    if let notifications = weakSelf?.serverParser?.parseNotifications(JSON) {
                        weakSelf?.storageService?.cleanUp({ (error) in
                            weakSelf?.storageService?.addNotifications(notifications, completion: { (error) in
                                if error == nil {
                                    let fetchedNotifications = weakSelf?.storageService?.fetch()
                                    completion(error:nil, notifications: fetchedNotifications)
                                    print("fetched notifications\(fetchedNotifications)")
                                }
                            })
                        })
                    }
                } else {
                    let fetchedNotifications = weakSelf?.storageService?.fetch()
                    completion(error: error, notifications: fetchedNotifications)
                }
            })
        }
    }
    
    
    
}
