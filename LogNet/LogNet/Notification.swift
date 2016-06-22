//
//  Notification.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class Notification: NSObject {
    dynamic var title:String?
    dynamic var text:String?
    dynamic var link:String?
    dynamic var time:NSNumber?
    dynamic var phone:String?
 
    override var description: String {
        get {
            return "title: \(self.title)"
        }
       
    }
}