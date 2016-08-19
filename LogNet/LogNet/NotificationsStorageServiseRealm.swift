//
//  NotificationsStorageServiseRealm.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationsStorageServiseRealm: NotificationsStorageServise {

	lazy var saveQueue: dispatch_queue_t = {
		let queue = dispatch_queue_create("com.lognet.notifications.queue", DISPATCH_QUEUE_SERIAL)
		return queue
	}()

    // MARK: Private
    
    private func addRealmObject(object: Object) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(object)
        try! realm.commitWrite()
    }
    
    // MARK: Public
    
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
    
	func cleanUp(completion: ErrorCompletionBlock) {
		dispatch_async(self.saveQueue) {
			autoreleasepool({
				let realm = try! Realm()
				realm.beginWrite()
				realm.deleteAll()
				try! realm.commitWrite()
				dispatch_async(dispatch_get_main_queue(), {
					completion(error: nil)
				})
			})
		}
	}

	func addNotification(notification: Notification, completion: ErrorCompletionBlock?) {
		dispatch_async(self.saveQueue) {
			autoreleasepool({
				self.addRealmObject(notification)
			})
		}
	}

	func addNotifications(notifications: [Notification], completion: ErrorCompletionBlock?) {
		dispatch_async(self.saveQueue) {
			autoreleasepool({
				for notification in notifications {
					self.addRealmObject(notification)
				}
				if completion != nil {
					dispatch_async(dispatch_get_main_queue(), {
						completion!(error: nil)
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
