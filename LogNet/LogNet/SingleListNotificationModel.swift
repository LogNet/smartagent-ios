//
//  NotificationsModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift

class SingleListNotificationModel: NSObject {
    var apiFacade:APIFacade?
    var serverParser:ServerParser?
    var storageService: NotificationsStorageServise?
    
    // MARK: Public methods
    
    func fetchNotifications(type:ListType, subtype:NotificationSubtype,offset:Int?, chunkSize:Int) -> Observable<Void> {
        return self.apiFacade!.getNotifications(type:type.rawValue,
                                                subtype:subtype,
                                                offset:offset, chunkSize: chunkSize)
            .flatMap{ JSON in
                return self.saveNotifications(JSON, type: type,subtype: subtype, offset: offset)
            }
    }

    private func saveNotifications(JSON:AnyObject, type:ListType, subtype:NotificationSubtype, offset:Int?) -> Observable<Void> {
        return self.parseJSON(JSON, listType: type).flatMap { notifications in
            self.storeNotifications(notifications, offset: offset, type: type, subtype: subtype)
        }
    }
    
    func storeNotifications(notifications:[Notification], offset:Int?, type:ListType, subtype:NotificationSubtype) -> Observable<Void> {
        return Observable.create{ observer in
            if offset == 0 {
                self.storageService?.deleteAllByType(type, subtype: subtype, completion: { [weak self](error) in
                    self?.storageService?.addNotifications(notifications, completion: { (error) in
                        if error == nil {
                            observer.onNext()
                            observer.onCompleted()
                        } else {
                            observer.onError(error!)
                        }
                    })
                })
            } else {
                self.storageService?.addNotifications(notifications, completion: { (error) in
                    if error == nil {
                        observer.onNext()
                        observer.onCompleted()
                    } else {
                        observer.onError(error!)
                    }

                })
            }
            
            return AnonymousDisposable {}
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
