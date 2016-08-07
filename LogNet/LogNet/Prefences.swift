//
//  Prefences.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/3/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

let PHONE_KEY = "TOKEN_KEY"

class Prefences {
    
    class func getPhone() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(PHONE_KEY) as? String
    }
    
    class func savePhone(phone: String) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(phone, forKey: PHONE_KEY)
    defaults.synchronize()
    }
}