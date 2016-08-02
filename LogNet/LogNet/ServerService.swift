//
//  ServerService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

enum NotificationType {
    case Recent
    case Reprice
    case Cancelled
    case TicketDue
}

protocol ServerService {
    func register(phoneNumber: String, first_name: String,
                  last_name: String, email: String, uuid: String) -> Observable<String>
    func getNotificationList(type:NotificationType,
                             subtype:String?,
                             from_id:Int?,
                             to_id:Int?,
                             from_time:NSTimeInterval?,
                             to_time:NSTimeInterval?,
                             chunks_size:Int?,
                             completion:JSONCompletionBlock?)
}