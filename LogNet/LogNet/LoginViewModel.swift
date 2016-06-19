//
//  LoginViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class LoginViewModel:NSObject {
    
    // MARK: Public Variables
    
    var phoneNumber:String?
    
    // MARK: Private Variables

    private var loginModel:LoginModel
    
    init (loginModel:LoginModel) {
        self.loginModel = loginModel
    }
    
    // MARK: Public methods
    
    func login(completion:(error:NSError?)->Void) -> Void {
        if self.phoneNumber != nil {
            self.loginModel.login(self.phoneNumber!) { (error:NSError?) in
                
            }
            print(self.phoneNumber!)
        }
        
    }
}