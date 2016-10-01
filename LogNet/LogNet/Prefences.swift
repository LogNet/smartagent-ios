//
//  Prefences.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/3/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

let PHONE_KEY = "PHONE_KEY"
let EMAIL_KEY = "EMAIL_KEY"
let FULL_NAME_KEY = "FULL_NAME_KEY"
let TOKEN_KEY = "TOKEN_KEY"
let CHUNK_SIZE = 20

class Prefences {
    
    class func savePhone(phone: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(phone, forKey: PHONE_KEY)
        defaults.synchronize()
    }
    
    class func getPhone() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(PHONE_KEY) as? String
    }
    
    class func saveEmail(email: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(email, forKey: EMAIL_KEY)
        defaults.synchronize()
    }
    
    class func getEmail() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(EMAIL_KEY) as? String
    }
    
    class func saveFullName(fullName: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(fullName, forKey: FULL_NAME_KEY)
        defaults.synchronize()
    }
    
    class func getFullName() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(FULL_NAME_KEY) as? String
    }
    
    class func saveToken(token: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: TOKEN_KEY)
        defaults.synchronize()
    }
    
    class func getToken() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(TOKEN_KEY) as? String
    }
}