//
//  GoandroidServerService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import Alamofire

class GoandroidServerService:LoginService,ServerService {
    private let TOKEN_KEY = "TOKEN_KEY"
    let baseURLString = "http://goandroid.net:8484"
    
    func login(phoneNumber: String, completion: JSONCompletionBlock?) {
        Alamofire.request(.POST, baseURLString + "/agent/register",parameters:["phoneNumber":phoneNumber]).responseJSON { response in
            if completion != nil {
                completion!(response.result.value,response.result.error)
            }
        }
    }
    
    func storeToken(token: String?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(token, forKey: TOKEN_KEY)
        defaults.synchronize()
    }
    
    func getToken() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(TOKEN_KEY) as? String
    }
    
    func postDeviceToken(deviceToken: String) {
        if let token = self.getToken() {
            let headers = ["token":token]
            Alamofire.request(.POST, baseURLString + "/push",parameters:["registrationId":deviceToken],headers:headers).responseJSON {
                response in
                
            }
        }
    }
    
    func getNotifications(completion: JSONCompletionBlock?) {
         if let token = self.getToken() {
            let headers = ["token":token]
            Alamofire.request(.GET, baseURLString + "/events", headers: headers).responseJSON { response in
                if completion != nil {
                    completion!(response.result.value, response.result.error)
                }
            }
        }
    }
    
}