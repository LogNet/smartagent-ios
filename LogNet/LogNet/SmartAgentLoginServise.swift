//
//  SmartAgentLoginServise.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/4/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class SmartAgentLoginServise: LoginService {
    let TOKEN_KEY = "TOKEN_KEY"
    func login(phoneNumber: String, name:String, completion: ErrorCompletionBlock?) {
        self.storeToken("token")
        if completion != nil {
            completion!(error: nil)
        }
    }
    
    func sendNotificationToken(notificationToken: String) {
        
    }
    
    func storeToken(token:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: TOKEN_KEY)
        defaults.synchronize()
    }
    
    func getToken() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(TOKEN_KEY) as! String?
    }
    
    func isAutorized() -> Bool {
        if self.getToken() != nil {
            return true
        }
        return false
    }

}
