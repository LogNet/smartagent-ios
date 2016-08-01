//
//  SmartAgentLoginServise.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/4/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import Alamofire
//import Firebase

class SmartAgentLoginServise: LoginService {
    let TOKEN_KEY = "TOKEN_KEY"
    let baseURLString = "http://62.90.233.18:8080/"
    func login(phoneNumber: String, first_name: String,
               last_name: String, email: String, uuid: String,
               completion: ErrorCompletionBlock?) {
        let parameters = ["device_number":phoneNumber, "email":email, "mac_address":uuid, "first_name":first_name, "last_name":last_name]
        Alamofire.request(.POST, baseURLString + "registerDevice",parameters:parameters).responseJSON {response in
            if completion != nil {
                if response.result.error == nil {
                    if let token = self.parseToken(response.result.value) {
                        self.storeToken(token)
                    } else {
                        let error = NSError(domain: "lognet.LogNet.LoginService", code: -6123, userInfo: [NSLocalizedDescriptionKey: "Token can't be parsed."])
                        completion!(error: error)
                    }
                } else {
                    completion!(error: response.result.error)
                }
            }
        }
    }
    
    func parseToken(JSON:AnyObject?) -> String? {
        if let token = JSON?["registration_token"] as? String {
            return token
        }
        return nil
    }
    
    func sendNotificationToken(notificationToken: String) {
        
    }
    
//    func registerFirebaseUser(token token:String)  {
//        
//    }
    
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
      return false
    }
    
    func isLoggedIn() -> Bool {
        if self.getToken() != nil {
            return true
        }
        return false
    }

}
