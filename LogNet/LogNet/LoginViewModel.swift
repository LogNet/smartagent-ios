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
    var name:String?
    var phoneNumber:String?
    // MARK: Private Variables

    private var loginModel:LoginModel
    
    init (loginModel:LoginModel, router:Router) {
        self.loginModel = loginModel
        super.init(router: router)
    }
    
    // MARK: Public methods
    
    func login(completion:(error:NSError?)->Void) -> Void {
        if self.phoneNumber != nil || self.name != nil {
            weak var weakSelf = self
            self.loginModel.login(self.phoneNumber!, name: self.name!) { (error:NSError?) in
                if error == nil {
                    weakSelf?.router.loginFinished()
                }
                completion(error: error)
            }
            print(self.phoneNumber!)
        }
        
    }
    
}