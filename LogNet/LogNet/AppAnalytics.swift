//
//  TrackerUtil.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 9/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class AppAnalytics {
    class func logEvent(event:String) {
        FIRAnalytics.logEventWithName(event, parameters: nil)
    }
    
    class func logEvent(event:String, parameters: [String : NSObject]) {
        FIRAnalytics.logEventWithName(event, parameters: parameters)
    }
}