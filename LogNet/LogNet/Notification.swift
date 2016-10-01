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

enum TypeStatus:String {
    case ACTIVE = "ACTIVE"
    case INACTIVE = "INACTIVE"
}

class Notification: Object {
    dynamic var notification_id:String!
    dynamic var status:String?
    dynamic var type:String?
    dynamic var sub_type:String?
    dynamic var title:String?
    dynamic var title_message:String?
    dynamic var notification_time:NSDate?
    dynamic var pnr_summary:String?
    dynamic var contact_name:String?
    dynamic var listType:String?
    dynamic var typeStatus:String?
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
    
    func getUITitle() -> String? {
        var title = ""
        if let text = self.title {
            title = text
        }
        
        if let text = self.title_message {
            title = "\(title) - \(text)"
        }
        return title
    }
    
    override func copy() -> AnyObject {
        let notification = Notification()
        notification.notification_id = self.notification_id
        notification.status = self.status
        notification.type = self.type
        notification.sub_type = self.sub_type
        notification.title = self.title
        notification.title_message = self.title_message
        notification.notification_time = self.notification_time
        notification.pnr_summary = self.pnr_summary
        notification.contact_name = self.contact_name
        notification.listType = self.listType
        notification.isDeleted = self.isDeleted
        notification.typeStatus = self.typeStatus
        return notification
    }
    
    override var description: String {
        get {
            return "title: \(self.title) date: \(self.notification_time)"
        }
    }
}