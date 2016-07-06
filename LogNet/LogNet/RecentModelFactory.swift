//
//  NotificationsModelFactory.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class RecentModelFactory {
    
    class func getSmartAgentRecentModel() -> RecentModel {
        let model = RecentModel()
        model.serverParser = SmartAgentParser()
        model.apiFacade = APIFacade(service: DummyServerService())
        model.storageService = NotificationsStorageServiseRealm()
        return model
    }
    
}