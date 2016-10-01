//
//  PushTokenUtil.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/27/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

let DEVICE_TOKEN_STRING = "DEVICE_TOKEN_STRING"


class PushTokenUtil: NSObject {
    
    dynamic var token:String?
    
    class func storePushToken(token: String?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(token, forKey: DEVICE_TOKEN_STRING)
        defaults.synchronize()
    }
    
    class func getPushToken() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(DEVICE_TOKEN_STRING) as? String
    }
    
    override init () {
        self.token = PushTokenUtil.getPushToken()
    }
    
}
