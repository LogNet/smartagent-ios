//
//  PNRDataModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PNRDataModel {
    var apiFacade:APIFacade!
    var serverParser:ServerParser!
    var storageService: AbstractNotificationsStorage!
    
    func getPNRInfo(notification_id:String) -> Observable<PNRInfo> {
        return self.apiFacade.getNotificationDetails(notification_id).flatMap { JSON in
            return self.parsePNRJSON(JSON)
        }
    }
    
    private func parsePNRJSON(JSON:AnyObject) -> Observable<PNRInfo> {
        return Observable.create { subscriber in
            let (pnrInfo, error) =  self.serverParser.parsePNRInfo(JSON)
            if pnrInfo != nil {
                subscriber.onNext(pnrInfo!)
                subscriber.onCompleted()
            } else {
                subscriber.onError(error!)
            }

            return AnonymousDisposable {}
        }
    }
    
    private func fetchFromDatabase(notification_id:String) -> PNRInfo {
        
    }
    
    private func savePNRInfo(pnrInfo: PNRInfo) -> Bool {
        
    }
}
