//
//  Prefences.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/3/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class Prefences {
    let PHONE_KEY = "TOKEN_KEY"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var phoneNumber: String? {
        set {
            self.userDefaults.setValue(phoneNumber, forKey: PHONE_KEY)
            self.userDefaults.synchronize()
        }
        get {
           return self.userDefaults.stringForKey(PHONE_KEY)
        }
    }
}