//
//  ActivationViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/7/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class ActivationViewModel: NSObject {
    private let model:SingleListNotificationModel

    let email = Prefences.getEmail()
    
    init(model:SingleListNotificationModel) {
        self.model = model
    }
    
    func isUserActivated() -> Observable<Bool> {
        return self.model.fetchNotifications(.Recent,subtype: .All, offset: 0).flatMap{ notifications in
            return Observable.just(true)
        }
    }
    
    func sendNotificationToken() {
        if FIRInstanceID.instanceID().token() != nil {
            print("InstanceID token: \(FIRInstanceID.instanceID().token())")
            let apiFacade = self.model.apiFacade
            apiFacade!.sendNotificationToken(FIRInstanceID.instanceID().token()!)
        }

    }
}