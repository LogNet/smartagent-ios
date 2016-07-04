//
//  GoandroidServerService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import Alamofire

class GoandroidServerService:ServerService {
    private let TOKEN_KEY = "TOKEN_KEY"
    let baseURLString = "http://goandroid.net:8484"
    
    func login(phoneNumber: String, name deviceToken:String, completion: ErrorCompletionBlock?) {
        
        Alamofire.request(.POST, baseURLString + "/push",parameters:["phoneNumber":phoneNumber, "token":deviceToken]).responseJSON { [weak self] response in
            if completion != nil {
                if response.result.error == nil {
                    self?.loginOtherOnServer(phoneNumber, deviceToken: deviceToken, completion: completion)
                } else {
                    completion!(error: response.result.error)
                }

            }
        }
    }
    
    func loginOtherOnServer(phoneNumber: String, deviceToken:String, completion:ErrorCompletionBlock?)  {
        Alamofire.request(.POST, "http://62.90.233.18:8080/agent/register",parameters:["phoneNumber":phoneNumber, "token":deviceToken]).responseJSON { response in
            if completion != nil {
                var error:NSError?
                if response.response?.statusCode != 201 {
                    error = NSError(domain: "com.GoandroidServerService", code: 1, userInfo: nil)
                }
                completion!(error: error)
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
    
//    func postDeviceToken(deviceToken: String) {
//        if let token = self.getToken() {
//            let headers = ["token":token]
//            Alamofire.request(.POST, baseURLString + "/push",parameters:["registrationId":deviceToken],headers:headers).responseJSON {
//                response in
//                
//            }
//        }
//    }
    
    func getNotifications(completion: JSONCompletionBlock?) {
         if let token = self.getToken() {
            let parameters = ["phoneNumber":token]
            Alamofire.request(.GET, baseURLString + "/events", parameters:parameters).responseJSON { response in
                if completion != nil {
                    completion!(response.result.value, response.result.error)
                }
            }
        }
    }
    
}