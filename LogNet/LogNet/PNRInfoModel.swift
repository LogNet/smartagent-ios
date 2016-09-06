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

class PNRInfoModel {
    var apiFacade:APIFacade!
    var serverParser:ServerParser!
    var pnrStorageService: AbstractPNRInfoStorage!
    var notificationStorageService: AbstractNotificationsStorage!

    private var disposeBag = DisposeBag()
    
    func getPNRInfo(notification_id:String) -> Observable<PNRInfo> {
        return Observable.create { observer in
            self.sendPNRFromStorage(notification_id, observer: observer)
            self.sendUpdatedPNRInfoFromServer(notification_id, observer: observer)
            return AnonymousDisposable {}
        }
    }
    
    // MARK: Private
    
    private func sendUpdatedPNRInfoFromServer(notification_id:String, observer:AnyObserver<PNRInfo>) {
        self.apiFacade.getNotificationDetails(notification_id).flatMap { JSON in
            return self.parsePNRJSON(JSON)
            }.subscribe(
                onNext: {result in
                    let pnrInfo = result.0
                    pnrInfo.notification_id = notification_id
                    pnrInfo.shareText = result.1.getShareText()
                    self.pnrStorageService.addPNFInfo(pnrInfo, completion: { (error) in
                    if error != nil {
                        observer.onError(error!)
                    }
                    self.notificationStorageService.updateNotification(result.1)
                    self.sendPNRFromStorage(notification_id, observer: observer)
                    observer.onCompleted()
                })
                },onError: { error in
                    observer.onError(error)
                    }, onCompleted: {
                        
                    }, onDisposed: {
                        print("onDisposed")
                }).addDisposableTo(self.disposeBag)
    }
    
    private func sendPNRFromStorage(notification_id:String, observer:AnyObserver<PNRInfo>) {
        do {
            if let pnr = try self.pnrStorageService.getPNFInfo(notification_id) {
                observer.onNext(pnr)
            } else {
                print("Has no pnr for this notificaion.")
            }
        } catch let error as NSError {
            observer.onError(error)
        }

    }
    
    
    private func parsePNRJSON(JSON:AnyObject) -> Observable<(PNRInfo, Notification)> {
        return Observable.create { subscriber in
            let (result, error) =  self.serverParser.parsePNRInfo(JSON)
            if result.0 != nil && result.1 != nil  {
                subscriber.onNext((result.0!, result.1!))
                subscriber.onCompleted()
            } else {
                subscriber.onError(error!)
            }
            return AnonymousDisposable {}
        }
    }
    
}
