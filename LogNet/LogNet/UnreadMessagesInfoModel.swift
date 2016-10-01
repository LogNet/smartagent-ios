//
//  UnreadMessagesInfoModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 9/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

class UnreadMessagesInfoModel {
    let apiFacade:APIFacade
    var parser:ServerParser!
    
    init(apiFacade:APIFacade) {
        self.apiFacade = apiFacade
    }
    
    func getUnreadMessages() -> Observable<UnreadMessagesInfo>{
        return self.apiFacade.getUnreadNotificationsCount().flatMap({ JSON in
            return self.parseJSON(JSON)
        })
    }
    
    func parseJSON(JSON:AnyObject) -> Observable<UnreadMessagesInfo> {
        return Observable.create { observer in
            let result = self.parser.parseUnreadMessagesInfo(JSON)
            if result.1 == nil {
                if result.0 != nil {
                    observer.onNext(result.0!)
                    observer.onCompleted()
                } else {
                    observer.onError(ErrorUtil.ErrorWithMessage("Can't parse unread messages."))
                }
            } else {
                observer.onError(result.1!)
            }
            return AnonymousDisposable {
                
            }
        }
    }
}