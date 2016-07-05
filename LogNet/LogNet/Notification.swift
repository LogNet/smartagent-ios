//
//  Notification.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class Notification: Object {
    dynamic var notification_id:String?
    dynamic var status:String?
    dynamic var type:String?
    dynamic var title:String?
    dynamic var title_message:String?
    dynamic var notification_time:NSDate?
    dynamic var pnr_summary:String?
    dynamic var contact_name:String?
 
    override var description: String {
        get {
            return "title: \(self.title) date: \(self.title_message)"
        }
       
    }
}