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
    
    func parseNotifications(JSON:AnyObject?) -> (array:Array<Notification>?, error:ErrorType?) {
        print(JSON)
        if let jsonDict = JSON as? [[String: AnyObject]] {
            var notifications = Array<Notification>()
            for jsonNotification in jsonDict {
                let notification = Notification()
                notification.notification_id = jsonNotification["notification_id"] as? String
                notification.status = jsonNotification["status"] as? String
                notification.type = jsonNotification["type"] as? String
                notification.sub_type = jsonNotification["sub_type"] as? String
                notification.title = jsonNotification["title"] as? String
                notification.title_message = jsonNotification["title_message"] as? String
                let time = jsonNotification["notification_time"] as? String
                notification.notification_time = self.dateFormatter.dateFromString(time!)
                notification.pnr_summary = jsonNotification["pnr_summary"] as? String
                notification.contact_name = jsonNotification["contact_name"] as? String

                notifications.append(notification)
            }
            return (notifications, nil);
        }
        if let error = self.checkOnErrorStatus(JSON!){
            return (nil, error)
        } else {
            return (nil, ApplicationError.Unknown)
        }

    }
    
    func checkOnErrorStatus(JSON:AnyObject) -> ErrorType? {
        let jsonDict = JSON as? [String: AnyObject]
        let code = jsonDict?["code"]
        let status = jsonDict?["status"]
        if (code != nil) && (status != nil) {
            return ErrorUtil.ErrorWithMessage(code as! String)
        }
        return nil
    }
}