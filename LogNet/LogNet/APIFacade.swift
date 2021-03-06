//
//  APIFacade.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/6/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

 class APIFacade {
    
	private var service: ServerService
    private var disposeBag = DisposeBag()
    init(service: ServerService) {
		self.service = service
	}
    
    func executePendingOperation(notificationID:String, op_code:String) -> Observable<AnyObject> {
        let observable = self.getCredentials().flatMap { (phone, token) in
            return self.service.executePendingOperation(token, phone: phone, notificationID: notificationID, op_code: op_code)
        }
        return observable
    }
    
    func deleteNotification(notificationID:String) -> Observable<Void> {
        let observable = self.getCredentials().flatMap { (phone, token) in
            return self.service.deleteNotification(phone, token: token, notification_id: notificationID)
        }
        return observable
    }
    
    func getNotificationDetails(notification_id:String) -> Observable<AnyObject> {
        let observable = self.getCredentials().flatMap { (phone, token) in
            return self.service.getNotificationData(phone, token: token, notification_id: notification_id)
        }
        return observable
    }
    
    func getNotifications(type type:String?, subtype:NotificationSubtype, offset: Int?, chunkSize: Int) -> Observable<AnyObject> {
        // Return sequense.
        let observable = self.getCredentials().flatMap { (phone, token) in
            return self.service.getNotificationList(phoneNumber:phone, token: token,
                type: type, subtype: subtype.rawValue, offset:offset, chunks_size: chunkSize)
        }
        return observable
	}
    
    func getUnreadNotificationsCount() -> Observable<AnyObject> {
        // Return sequense.
        let observable = self.getCredentials().flatMap { (phone, token) in
            return self.service.getUnreadNotificationsCount(phoneNumber: phone, token: token)
        }
        return observable
    }
    
    func register(phoneNumber: String, first_name: String,
                  last_name: String, email: String, uuid: String) -> Observable<()> {
        let observable = self.service.register(phoneNumber, first_name: first_name, last_name: last_name, email: email, uuid: uuid).flatMap {token in
            self.authorizeFirebase(token)
        }.flatMap {_ in
            self.getFirebaseUserToken()
        }.flatMap { userToken in
            self.savePrefences(phoneNumber, first_name: first_name, last_name: last_name, email: email,token: userToken)
        }
        return observable
    
    }
    
    func sendNotificationToken(token:String) {
        let phone = Prefences.getPhone()
        let userToken = Prefences.getToken()
        if phone != nil && userToken != nil {
            self.service.sendNotificationToken(token, phone: phone!, registrationToken: userToken!).subscribeNext{}.addDisposableTo(self.disposeBag)
        }
    }
    
    // MARK: - Private Methods
    
    private func getCredentials() -> Observable<(String, String)> {
        let phone = Prefences.getPhone()
        if phone == nil {
            return Observable.create{ observer -> Disposable in
                observer.onError(ApplicationError.FORBIDDEN)
                return AnonymousDisposable {}
            }
        }
        // Return sequense.
        let observable = self.getFirebaseUserToken().flatMap{ token in
            return Observable.just((phone!, token))
        }
        return observable
    }
    
    private func savePrefences(phoneNumber: String, first_name: String,
                               last_name: String, email: String, token:String) -> Observable<()> {
        return Observable.create { observer in
            Prefences.savePhone(phoneNumber)
            Prefences.saveEmail(email)
            Prefences.saveFullName("\(last_name) \(first_name)")
            Prefences.saveToken(token)
            observer.onCompleted()
            return AnonymousDisposable {}
        }
    }
    
    private func getFirebaseUserToken() -> Observable<String> {
        return Observable.create({ (subscriber) -> Disposable in
            if let user = FIRAuth.auth()?.currentUser {
                // User is signed in.
                user.getTokenForcingRefresh(false, completion: { (token, error) in
                    if token != nil && error == nil {
                        subscriber.onNext(token!)
                        subscriber.onCompleted()
                    } else if error != nil {
                        subscriber.onError(error!)
                    } else {
                        subscriber.onError(NSError(domain: "APIFacade",
                            code: 771,
                            userInfo: [NSLocalizedDescriptionKey:"Firebase token == nil"]))
                    }
                })
            } else {
                subscriber.onError(ApplicationError.FORBIDDEN)
            }
            return AnonymousDisposable {}
        })
    }
    
    private func authorizeFirebase(token:String) -> Observable<FIRUser> {
        return Observable.create { (subscriber) -> Disposable in
            FIRAuth.auth()?.signInWithCustomToken(token) { (user, error) in
                if user != nil && error == nil {
                    subscriber.onNext(user!)
                    subscriber.onCompleted()
                } else if error != nil {
                    subscriber.onError(error!)
                } else {
                    subscriber.onError(NSError(domain: "APIFacade",
                                                 code: 771,
                                             userInfo: [NSLocalizedDescriptionKey:"Cant't  sign in with firebase"]))
                }
            }
            return AnonymousDisposable { }
        }
    }
    
}