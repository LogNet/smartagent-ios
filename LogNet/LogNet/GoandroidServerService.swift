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
    
    let baseURLString = "http://goandroid.net:8484"
    
    func login(phoneNumber: String, completed: ((AnyObject?,NSError?)->Void)) {
        Alamofire.request(.POST, baseURLString + "/token",parameters:["phone":phoneNumber]).responseJSON { response in
            completed(response.result.value,response.result.error)
        }
    }
}