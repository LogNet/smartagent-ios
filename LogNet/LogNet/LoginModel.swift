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
    
    func login(phoneNumber:String, name:String, completed: (NSError?)->Void) {
        loginService.login(phoneNumber,name:name) { (error:NSError?) in
            completed(error)
        }
    }
    
    // MARK: Private methods
    
}