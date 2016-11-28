//
//  LoginViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel:ViewModel {
    
    private let environmentSetter = EnvironmentSetter(maxTapsCount: 20)

    // MARK: Public Variables

    var full_name:String?
    var phoneNumber:String?
    var email:String?
    var canSetHost:Variable<Bool> {
        get {
            return self.environmentSetter.openHostSettings
        }
    }
    // MARK: Private Variables
    
    private var loginModel:LoginModel
    
    init (loginModel:LoginModel, router:Router) {
        self.loginModel = loginModel
        super.init(router: router)
    }
    
    // MARK: Public methods
    
    func login(completion:(error:NSError?)->Void) -> Void {
        if self.phoneNumber != nil && self.full_name != nil && self.email != nil {
            self.loginModel.login(self.phoneNumber!, full_name: self.full_name!, email: self.email!, completed: {[weak self] (error) in
                if error == nil {
                   self!.router.loginFinished()
                }
                completion(error: error)
            })
        }
        
    }
    
    func clickToSetHost() {
        self.environmentSetter.tap()
    }
    
    func changeDefaultURL(url:String?) {
        EnvironmentSetter.setDefaultURL(url)
    }
}