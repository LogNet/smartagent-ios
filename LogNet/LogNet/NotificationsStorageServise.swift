//
//  StorageServise.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol NotificationsStorageServise {
    
    func deleteAllByType(type: ListType,subtype:NotificationSubtype,completion:ErrorCompletionBlock)
    func addNotification(notification:Notification, completion:ErrorCompletionBlock?)
    func addNotifications(notifications:[Notification],completion:ErrorCompletionBlock?)
    func search(query: String) throws -> [Notification]?
    
}

