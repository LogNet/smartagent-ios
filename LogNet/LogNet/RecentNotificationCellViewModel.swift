//
//  NotificationCellViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class NotificationCellViewModel {
    var title:String?
    var text:String?
    var link:String?
    var date:String?
    private var notification:Notification
    
    init(notification: Notification) {
        self.notification = notification
        self.setupView()
    }
    
    func setupView() {
//        self.title = notification.
    }
}