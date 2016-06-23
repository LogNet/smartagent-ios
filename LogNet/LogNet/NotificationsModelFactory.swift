//
//  NotificationsModelFactory.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class NotificationsModelFactory {
    
    class func getGoandroidNotificationsModel() -> NotificationsModel {
        let model = NotificationsModel()
        model.serverParser = GoandroidServerParser()
        model.servserService = GoandroidServerService()
        model.storageService = NotificationsStorageServiseRealm()
        return model
    }
    
}