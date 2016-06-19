//
//  ServierService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol ServierService {
    func login(phoneNumber:String, completed:(NSError?))
}