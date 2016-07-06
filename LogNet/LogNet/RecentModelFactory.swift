//
//  NotificationsModelFactory.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class RecentModelFactory {
    
    class func getGoandroidNotificationsModel() -> RecentModel {
        let model = RecentModel()
        model.serverParser = SmartAgentParser()
        model.servserService = SmartAgentServerServise()
        model.storageService = NotificationsStorageServiseRealm()
        return model
    }
    
}