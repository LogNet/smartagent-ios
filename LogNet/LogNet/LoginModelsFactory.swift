//
//  LoginModelsFactory.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class LoginModelsFactory {
    class func getLoginModel() -> LoginModel {
        let serverService = SmartAgentServerServise()
        let apiFacade = APIFacade(service: serverService)
        let loginModel = LoginModel(apiFacade: apiFacade)
        loginModel.parser = SmartAgentParser()
        return loginModel
    }
}