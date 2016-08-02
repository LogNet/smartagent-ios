//
//  DummyServerService.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/6/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class DummyServerService {
    
    func getNotificationList(type: NotificationType, subtype: String?, from_id: Int?, to_id: Int?, from_time: NSTimeInterval?, to_time: NSTimeInterval?, chunks_size: Int?, completion: JSONCompletionBlock?) {
        if (completion != nil) {
            completion!(self.JSONFromBundle(self.JSONNameForType(type)),nil)
        }
    }
    
    func JSONFromBundle(name: String) -> AnyObject? {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        let data = NSData(contentsOfFile: path!)
        let JSON =  try! NSJSONSerialization.JSONObjectWithData(data!, options:.MutableContainers)
        return JSON
    }
    
    
    
    func JSONNameForType(type:NotificationType) -> String {
        var name:String?
        switch type {
        case .Reprice:
            name = "reprice"
            break
        case .Cancelled:
            name = "cancelled"
            break
        case .TicketDue:
            name = "ticketdue"
            break
        default:
            name = "recent"
        }
        return name!
    }
    
}
