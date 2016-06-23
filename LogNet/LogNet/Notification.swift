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
    dynamic var title:String?
    dynamic var text:String?
    dynamic var link:String?
    dynamic var time:String?
    dynamic var phone:String?
 
    override var description: String {
        get {
            return "title: \(self.title)"
        }
       
    }
}