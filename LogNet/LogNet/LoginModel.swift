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
    
    private var serverService:ServerService
    
    init (serverService:ServerService) {
        self.serverService = serverService
    }
    
    // MARK: Public methods
    
    class func isUserLoggedIn() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
    }
    
    func login(phoneNumber:String, completed: (NSError?)->Void) {
        weak var weakSelf = self
        serverService.login(phoneNumber) { (JSON:AnyObject?, error:NSError?) in
            if let token = weakSelf?.parser?.parseToken(JSON) {
                 print("parsed token: " + token)
                FIRAuth.auth()?.signInWithCustomToken(token, completion: { (user:FIRUser?, error:NSError?) in
                    
                })
            }
        }
    }
    
    // MARK: Private methods

    
}