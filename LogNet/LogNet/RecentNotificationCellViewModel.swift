//
//  NotificationCellViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class RecentNotificationCellViewModel {
    lazy var dateFormatter:NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .MediumStyle
        return dateFormatter
    }()
    var title:String?
    var contactName:String?
    var pnrSummary:String?
    var date:String?
    private var notification:Notification
    
    init(notification: Notification) {
        self.notification = notification
        self.setupView()
    }
    
    func setupView() {
        self.title = self.notification.title
        self.contactName = self.notification.contact_name;
        self.pnrSummary = self.notification.pnr_summary
        if let time = self.notification.notification_time {
            self.date = self.dateFormatter.stringFromDate(time)
        }
    }
}