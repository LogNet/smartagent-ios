//
//  Notification.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

enum ListType: String {
    case Recent = ""
    case Reprice = "RP"
    case TicketingDue = "TD"
    case Cancelled = "C"
}

enum NotificationSubtype:String {
    case All = ""
    case Pending = "PENDING"
    case Complete = "COMPLETE"
}

class Notification: Object {
    dynamic var notification_id:String?
    dynamic var status:String?
    dynamic var type:String?
    dynamic var sub_type:String?
    dynamic var title:String?
    dynamic var title_message:String?
    dynamic var notification_time:NSDate?
    dynamic var pnr_summary:String?
    dynamic var contact_name:String?
    dynamic var listType:String?
    dynamic var isDeleted = false
    
    func getShareText() -> String {
        var text = ""
        if let title = self.title {
            text = title
        }
        if let message = self.title_message{
            text += "\n\(message)"
        }
        if let summary = self.pnr_summary{
            text += "\n\(summary)"
        }
        return text
    }
    
    override var description: String {
        get {
            return "title: \(self.title) date: \(self.notification_time)"
        }
       
    }
}