//
//  ServerService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

protocol ServerService {
    func register(phoneNumber: String, first_name: String,
                  last_name: String, email: String, uuid: String) -> Observable<String>
    func getNotificationList(phoneNumber phoneNumber:String,
                             token:String,
                             type:String?,
                             subtype:String?,
                             offset:Int?,
                             chunks_size:Int?) -> Observable<AnyObject>
}