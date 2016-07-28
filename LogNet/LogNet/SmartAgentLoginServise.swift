//
//  SmartAgentLoginServise.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/4/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import Alamofire

class SmartAgentLoginServise: LoginService {
    let TOKEN_KEY = "TOKEN_KEY"
    let baseURLString = "https://62.90.233.18:8443/"
    func login(phoneNumber: String, first_name: String,
               last_name: String, email: String, uuid: String,
               completion: ErrorCompletionBlock?) {
        let parameters = ["device_number":phoneNumber, "email":email, "mac_address":uuid, "first_name":first_name, "last_name":last_name]
        Alamofire.request(.POST, baseURLString + "/registerDevice",parameters:parameters).responseJSON {response in
            if completion != nil {
                if response.result.error == nil {
                } else {
                    completion!(error: response.result.error)
                }
                
            }
        }
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
