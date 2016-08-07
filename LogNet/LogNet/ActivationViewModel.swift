//
//  ActivationViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/7/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

class ActivationViewModel: NSObject {
    private let model:SingleListNotificationModel

    let email = Prefences.getEmail()
    
    init(model:SingleListNotificationModel) {
        self.model = model
    }
    
    func isUserActivated() -> Observable<Bool> {
        return self.model.getNotifications(.Recent, fromID: 0, chunkSize: 20).flatMap{ notifications in
            return Observable.just(true)
        }
    }
}