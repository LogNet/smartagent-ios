//
//  ServerService.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol ServerService {
    func getNotificationList(type:String?,
                          subtype:String?,
                          from_id:Int?,
                            to_id:Int?,
                        from_time:NSTimeInterval?,
                          to_time:NSTimeInterval?,
                      chunks_size:Int?,
                       completion:JSONCompletionBlock?)
}