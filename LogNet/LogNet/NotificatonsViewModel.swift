//
//  NotificatonsTVCViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class NotificatonsTVCViewModel: ViewModel {
    
    var model:NotificationsModel
    
    init(model:NotificationsModel, router:Router) {
        self.model = model
        super.init(router: router)
    }
    
    func getNotifications() {
        self.model .getNotifications { (error, notifications) in
            
        }
    }
    
}
