//
//  LoginModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginModel {
    
    var parser:ServerParser?
    
    private var loginService:LoginService
    
    init (loginService:LoginService) {
        self.loginService = loginService
    }
    
    // MARK: Public methods
    
    class func isUserLoggedIn() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
    }
    
    func login(phoneNumber:String, deviceToken:String, completed: (NSError?)->Void) {
        weak var weakSelf = self
        loginService.login(phoneNumber,deviceToken: deviceToken) { (error:NSError?) in
            if error == nil {
                weakSelf?.loginService.storeToken(phoneNumber)
            }
            completed(error)
        }
    }
    
    // MARK: Private methods
    
}