//
//  LoginViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class LoginViewModel:NSObject {
    
    var router:LoginViewModelRouter?
    
    // MARK: Public Variables
    
    var phoneNumber:String?
    
    // MARK: Private Variables

    private var loginModel:LoginModel
    
    init (loginModel:LoginModel, router:Router?) {
        self.loginModel = loginModel
        self.router = router
    }
    
    // MARK: Public methods
    
    func login(completion:(error:NSError?)->Void) -> Void {
        if self.phoneNumber != nil {
            weak var weakSelf = self
            self.loginModel.login(self.phoneNumber!) { (error:NSError?) in
                if error == nil {
                    weakSelf?.router?.loginFinished()
                }
                completion(error: error)
            }
            print(self.phoneNumber!)
        }
        
    }
    
}