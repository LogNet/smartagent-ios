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

        }
    }
    
}
