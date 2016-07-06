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
    
    func getNotifications(completion:((error:NSError?, notifications:Array<Notification>?)->Void)) {
        self.apiFacade?.getRecentNotifications(0, chunkSize: 20, completion: { [weak self] (JSON:AnyObject?, error:NSError?) in
            let notifications = self?.serverParser?.parseNotifications(JSON)
            print("notifications: \(notifications)")
        })
    }
    
}
