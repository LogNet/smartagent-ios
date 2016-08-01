//
//  LoginViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class LoginViewModel:ViewModel {
    
    // MARK: Public Variables
    var full_name:String?
    var phoneNumber:String?
    var email:String?
    // MARK: Private Variables

    private var loginModel:LoginModel
    
    init (loginModel:LoginModel, router:Router) {
        self.loginModel = loginModel
        super.init(router: router)
    }
    
    // MARK: Public methods
    
    func login(completion:(error:NSError?)->Void) -> Void {
        if self.phoneNumber != nil && self.full_name != nil && self.email != nil {
            weak var weakSelf = self
            self.loginModel.login(self.phoneNumber!, full_name: self.full_name!, email: self.email!, completed: { (error) in
                if error == nil {
                   weakSelf?.router.loginFinished()
                }
                completion(error: error)
            })
        }
        
    }
    
}