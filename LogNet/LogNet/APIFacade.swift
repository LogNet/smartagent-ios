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
    private var prefences: Prefences
    init(service: ServerService, prefences:Prefences) {
		self.service = service
        self.prefences = prefences
	}

    func getRecentNotifications(fromID: Int?, chunkSize: Int8) -> Observable<AnyObject> {
        let observable = self.getFirebaseUserToken().flatMap{ token in
            return self.service.getNotificationList(AuthHeaders(token:token,phoneNumber:self.prefences.phoneNumber!),type: .Recent, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil)
        }
        return observable
	}
    
    func getRepriceNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?) {
//        self.service.getNotificationList(.Reprice, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil, completion: completion)
    }
    
    func getCancelledNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?) {
//        self.service.getNotificationList(.Cancelled, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil, completion: completion)
    }
    
    func getTickedDueNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?) {
//        self.service.getNotificationList(.TicketDue, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil, completion: completion)
    }
    
    func register(phoneNumber: String, first_name: String,
                  last_name: String, email: String, uuid: String) -> Observable<()> {
        let observable = self.service.register(phoneNumber, first_name: first_name, last_name: last_name, email: email, uuid: uuid).flatMap {token in
            self.authorizeFirebase(token)
        }.flatMap {_ in
            self.getFirebaseUserToken()
        }.flatMap { userToken in
             return Observable.just()
        }
        return observable
    
    }
    
    func getFirebaseUserToken() -> Observable<String> {
        return Observable.create({ (subscriber) -> Disposable in
            if let user = FIRAuth.auth()?.currentUser {
                // User is signed in.
                user.getTokenWithCompletion({ (token, error) in
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
                subscriber.onError(AppError.FORBIDDEN)
            }
            return AnonymousDisposable {}
        })
    }
    
    func authorizeFirebase(token:String) -> Observable<FIRUser> {
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
                                             userInfo: [NSLocalizedDescriptionKey:"Cant't  sisgn in with firebase"]))
                }
            }
            return AnonymousDisposable { }
        }
    }
    
}