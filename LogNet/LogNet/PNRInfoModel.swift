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

enum PNROperationAction:String {
    case Reprice = "RP"
    case Cancel = "C"
    case ContinueRepricing = "CR"
    case StopRepricing = "SR"
}

class PNRInfoModel {
    var apiFacade:APIFacade!
    var serverParser:ServerParser!
    var pnrStorageService: AbstractPNRInfoStorage!
    var notificationStorageService: AbstractNotificationsStorage!

    private var disposeBag = DisposeBag()
    
    func getPNRInfo(notification_id:String) -> Observable<(PNRInfo, Notification)> {
        return Observable.create { observer in
            self.sendFromStorage(notification_id, observer: observer)
            self.sendUpdatedPNRInfoFromServer(notification_id, observer: observer)
            return AnonymousDisposable {}
        }
    }
    
    func executePendingOperation(notification_id:String, action:PNROperationAction) -> Observable<(PNRInfo, Notification)> {
        return Observable.create { observer in
            self.apiFacade.executePendingOperation(notification_id, op_code: action.rawValue).flatMap{ JSON in
                return self.parsePNRJSON(JSON)
                // TODO: Need refactoring.
                }.subscribe(
                    onNext: {result in
                        self.notificationStorageService.updateNotification(result.1)
                        self.sendFromStorage(notification_id, observer: observer)
                        observer.onCompleted()
                    },onError: { error in
                        observer.onError(error)
                    }, onCompleted: {
                        
                    }, onDisposed: {
                        print("onDisposed")
                }).addDisposableTo(self.disposeBag)
            
            return AnonymousDisposable {}
        }
    }
    
    // MARK: Private
    
    private func sendUpdatedPNRInfoFromServer(notification_id:String, observer:AnyObserver<(PNRInfo, Notification)>) {
        self.apiFacade.getNotificationDetails(notification_id).flatMap { JSON in
            return self.parsePNRJSON(JSON)
            // TODO: Need refactoring.
            }.subscribe(
                onNext: {result in
                    let pnrInfo = result.0
                    if pnrInfo.isValid == false {
                        observer.onError(NSError.error(message: "Wrong PNR data.", doman: "PNRInfoModel"))
                    }
                    pnrInfo.notification_id = notification_id
                    self.pnrStorageService.addPNFInfo(pnrInfo, completion: { (error) in
                    if error != nil {
                        observer.onError(error!)
                    }
                    self.notificationStorageService.updateNotification(result.1)
                    self.sendFromStorage(notification_id, observer: observer)
                    observer.onCompleted()
                })
                },onError: { error in
                    observer.onError(error)
                    }, onCompleted: {
                        
                    }, onDisposed: {
                        print("onDisposed")
                }).addDisposableTo(self.disposeBag)
    }
    
    private func sendFromStorage(notification_id:String, observer:AnyObserver<(PNRInfo, Notification)>) {
        do {
            if let pnr = try self.pnrStorageService.getPNFInfo(notification_id) {
                do {
                    if let notification = try self.notificationStorageService.notificationByID(notification_id) {
                        observer.onNext((pnr, notification.copy() as! Notification))
                    } else {
                        print("Has no notification for this id.")
                    }
                } catch let error as NSError {
                    observer.onError(error)
                }
               
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
