//
//  NotificationsModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift

class SingleListNotificationModel {
    var apiFacade:APIFacade?
    var serverParser:ServerParser?
    var storageService: AbstractNotificationsStorage?
    let chunkSize:Int
    
    init(chunkSize:Int) {
        self.chunkSize = chunkSize
    }
    
    // MARK: Public methods
    
    func fetchNotifications(type:ListType, subtype:NotificationSubtype,offset:Int?) -> Observable<Bool> {
        return self.apiFacade!.getNotifications(type:type.rawValue,
                                                subtype:subtype,
                                                offset:offset, chunkSize: self.chunkSize + 1)
            .flatMap{ JSON in
                return self.saveNotifications(JSON, type: type,subtype: subtype, offset: offset)
            }
    }
    
    func storeNotifications(notifications:[Notification], offset:Int?, type:ListType, subtype:NotificationSubtype) -> Observable<Bool> {
        return Observable.create{ observer in
            var hasNextChunk = false
            var notifications_to_save = notifications
            if notifications_to_save.count > self.chunkSize {
                hasNextChunk = true
                notifications_to_save.removeLast()
            }
            if offset == 0 {
                self.storageService?.deleteAllByType(type, subtype: subtype, completion: { [weak self](error) in
                    self?.storageService?.addNotifications(notifications_to_save, completion: { (error) in
                        if error == nil {
                            observer.onNext(hasNextChunk)
                            observer.onCompleted()
                        } else {
                            observer.onError(error!)
                        }
                    })
                })
            } else {
                self.storageService?.addNotifications(notifications_to_save, completion: { (error) in
                    if error == nil {
                        observer.onNext(hasNextChunk)
                        observer.onCompleted()
                    } else {
                        observer.onError(error!)
                    }

                })
            }
            
            return AnonymousDisposable {}
        }
    }
    
    
    // MARK: Private methods

    private func saveNotifications(JSON:AnyObject, type:ListType, subtype:NotificationSubtype, offset:Int?) -> Observable<Bool> {
        return self.parseJSON(JSON, listType: type).flatMap { notifications in
            self.storeNotifications(notifications, offset: offset, type: type, subtype: subtype)
        }
    }
    
    private func parseJSON(JSON:AnyObject, listType:ListType) -> Observable<[Notification]> {
        return Observable.create{ observer in
            let result = self.serverParser?.parseNotifications(JSON, listType: listType)
            if result?.array != nil {
                observer.onNext(result!.array!)
            } else {
                observer.onError(result!.error!)
            }
            return AnonymousDisposable { }
        }
    }
}
