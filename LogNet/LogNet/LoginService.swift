//
//  ServierService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol LoginService {
    func login(phoneNumber: String, name:String, completion: ErrorCompletionBlock?)
    func sendNotificationToken(notificationToken:String)
    func getToken() -> String?
    func isAutorized() -> Bool
}