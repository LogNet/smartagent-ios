//
//  NotificationCellViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit

class RecentNotificationCellViewModel {
    lazy var dateFormatter:NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
    }()
    let rowHeight = CGFloat(77.0)
    var title:String?
    var titleMessage:String?
    var contactName:String?
    var pnrSummary:String?
    var date:String?
    var image:UIImage?
    private var notification:Notification
    
    init(notification: Notification) {
        self.notification = notification
        self.setupView()
    }
    
    func setupView() {
        self.titleMessage = self.notification.title_message
        self.title = self.notification.title
        self.contactName = self.notification.contact_name;
        self.pnrSummary = self.notification.pnr_summary
        if let time = self.notification.notification_time {
            self.date = self.dateFormatter.stringFromDate(time)
        }
        self.setupImage()
    }
    
    func setupImage() {
        guard let type = self.notification.type else {
            return
        }
        switch type {
        case "RP":
            self.image = UIImage(named: "Refund Filled")
            break
        case "C":
            self.image = UIImage(named: "Cancelled Filled circle")
            break
        case "TD":
            self.image = UIImage(named: "Ticket Filled circle")
            break
        default:
            break
        }
    }
}