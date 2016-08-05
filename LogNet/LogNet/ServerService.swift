//
//  ServerService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

struct AuthHeaders {
    var token:String
    var phoneNumber:String
}

protocol ServerService {
    func register(phoneNumber: String, first_name: String,
                  last_name: String, email: String, uuid: String) -> Observable<String>
    func getNotificationList(authHeaders:AuthHeaders,
                             type:String?,
                             subtype:String?,
                             offset:Int?,
                             chunks_size:Int?) -> Observable<AnyObject>
}