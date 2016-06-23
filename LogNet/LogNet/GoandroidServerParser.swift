//
//  GoandroidServerParser.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class GoandroidServerParser: ServerParser {
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
                notification.title = jsonNotification["title"] as? String
                notification.link = jsonNotification["link"] as? String
                let interval = jsonNotification["time"] as? Double
                notification.time = NSDate(timeIntervalSince1970: interval! / 1000.0)
                notification.text = jsonNotification["text"] as? String
                notification.phone = jsonNotification["phone"] as? String
                notifications.append(notification)
            }
            return notifications;
        }
        return nil
    }
    
}