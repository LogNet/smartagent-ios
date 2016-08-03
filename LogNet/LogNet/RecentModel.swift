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
    
    func getNotifications(fromID:Int?, chunkSize:Int8) -> Observable<AnyObject> {
        return (self.apiFacade?.getRecentNotifications(fromID, chunkSize: 20))!
    }
    
    
}
