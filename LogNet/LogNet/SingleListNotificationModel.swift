//
//  NotificationsModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift

enum NotificationType:String {
    case Recent = ""
    case Reprice = "RP"
    case Cancelled = "C"
    case TicketDue = "TD"
}

class SingleListNotificationModel: NSObject {
    var apiFacade:APIFacade?
    var serverParser:ServerParser?
    var storageService: NotificationsStorageServise?
    
    // MARK: Public methods
    
    func getNotifications(type:NotificationType,fromID:Int?, chunkSize:Int8) -> Observable<[Notification]> {
        return self.apiFacade!.getNotifications(type:type.rawValue, offset:fromID, chunkSize: 20).flatMap{ JSON in
            return self.parseJSON(JSON)
        }
    }
    
    private func parseJSON(JSON:AnyObject) -> Observable<[Notification]> {
        return Observable.create{ observer in
            let result = self.serverParser?.parseNotifications(JSON)
            if result?.array != nil {
                observer.onNext(result!.array!)
            } else {
                observer.onError(result!.error!)
            }
            return AnonymousDisposable { }
        }
    }
}
