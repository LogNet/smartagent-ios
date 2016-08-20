//
//  NotificationsStorageServiseRealm.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationsStorageServiseRealm: RealmStorage, NotificationsStorageServise {

    override init() {
        super.init()
        self.saveQueue = dispatch_queue_create("com.lognet.notification.queue", DISPATCH_QUEUE_SERIAL)
    }
    
    // MARK: Public
    
    func addNotification(notification: Notification, completion: ErrorCompletionBlock?) {
        self.addObject(notification, completion: completion)
    }
    
    func addNotifications(notifications: [Notification], completion: ErrorCompletionBlock?) {
        self.addObjects(notifications, completion: completion)
    }
    
    func deleteAllByType(type: ListType, subtype:NotificationSubtype, completion: ErrorCompletionBlock) {
        dispatch_async(self.saveQueue) {
            autoreleasepool({
                do {
                    let realm = try Realm()
                    let notifications = realm.objects(Notification.self).filter(subtype == .All ? "listType == '\(type.rawValue)'" : "listType == '\(type.rawValue)' AND sub_type == '\(subtype.rawValue)'")
                    if notifications.count > 0 {
                        realm.beginWrite()
                        realm.delete(notifications)
                        do {
                            try realm.commitWrite()
                        } catch let error as NSError {
                            dispatch_async(dispatch_get_main_queue(), {
                                completion(error: error)
                            })
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(error: nil)
                    })

                } catch let error as NSError {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(error: error)
                    })
                }
            })
        }
    }


    
    func search(query: String) throws -> [Notification]? {
        let realm = try Realm()
        let notifications = realm.objects(Notification.self).filter("title CONTAINS \(query) OR title_massage CONTAINS \(query)")
        return Array(notifications)
    }
}
