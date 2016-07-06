//
//  GoandroidServerParser.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class SmartAgentParser: ServerParser {
    
    lazy var dateFormatter:NSDateFormatter = {
       let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
    
    func parseToken(JSON: AnyObject?) -> String? {
        if JSON != nil {
            let token = JSON!["token"] as! String
            return token
        }
        return nil
    }
    
    func parseNotifications(JSON:AnyObject?) -> Array<Notification>? {
        print(JSON)
        if let jsonNotifications = JSON as? [[String: AnyObject]]{
            var notifications = Array<Notification>()
            for jsonNotification in jsonNotifications {
                let notification = Notification()
                notification.notification_id = jsonNotification["notification_id"] as? String
                notification.status = jsonNotification["status"] as? String
                notification.type = jsonNotification["status"] as? String
                notification.title = jsonNotification["status"] as? String
                notification.title_message = jsonNotification["status"] as? String
                let time = jsonNotification["notification_time"] as? String
                notification.notification_time = self.dateFormatter.dateFromString(time!)
                notification.pnr_summary = jsonNotification["pnr_summary"] as? String
                notifications.append(notification)
            }
            return notifications;
        }
        return nil
    }
    
}