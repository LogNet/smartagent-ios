//
//  ServierService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol LoginService {
    func login(phoneNumber: String, completion: JSONCompletionBlock?)
    func storeToken(token:String?)
    func getToken() -> String?
}