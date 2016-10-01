//
//  NotificationsStorageServiseRealm.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationsStorageRealm: RealmStorage, AbstractNotificationsStorage {

    override init() {
        super.init()
        self.saveQueue = dispatch_queue_create("com.lognet.notification.queue", DISPATCH_QUEUE_SERIAL)
    }
    
    // MARK: Public
    
    func notificationByID(notification_id:String) throws -> Notification? {
        let realm = try Realm()
        let notifications = realm.objects(Notification.self).filter("notification_id == '\(notification_id)'")
        return notifications.first
    }

    
    func markAsDeleted(notification_id:String) throws {
        let realm = try Realm()
        let notifications = realm.objects(Notification.self).filter("notification_id == '\(notification_id)'")
        realm.beginWrite()
        for notif in notifications{
            notif.isDeleted = true
        }
        try realm.commitWrite()
    }
    
    func updateNotification(notification:Notification) {
        let realm = try! Realm()
        let notifications = realm.objects(Notification.self).filter("notification_id == '\(notification.notification_id!)'")
        realm.beginWrite()
        for notif in notifications{
            notif.status = notification.status
            notif.type = notification.type
            notif.sub_type = notification.sub_type
            notif.title = notification.title
            notif.title_message = notification.title_message
            notif.notification_time = notification.notification_time
            notif.pnr_summary = notification.pnr_summary
            notif.contact_name = notification.pnr_summary
            notif.typeStatus = notification.typeStatus
        }
        try! realm.commitWrite()
    }

    
    func getSuggestTitles(query:String) throws -> [String]? {
        let notifications = try self.search(query)
        if notifications?.count > 0{
            return notifications!.map{
                return $0.title!.containsString(query) ? $0.title! : $0.title_message!
            }.unique
        }
        return []
    }

    
    func addNotification(notification: Notification, completion: ErrorCompletionBlock?) {
        self.addObject(notification, update: false, completion: completion)
    }
    
    func addNotifications(notifications: [Notification], completion: ErrorCompletionBlock?) {
        self.addObjects(notifications, update: false, completion: completion)
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
    
        if query.containsString("\\") {
            return nil
        }
        let realm = try Realm()
        let notifications = realm.objects(Notification.self).filter("title CONTAINS '\(query)' OR title_message CONTAINS '\(query)'")
        return Array(notifications)
    }
}
