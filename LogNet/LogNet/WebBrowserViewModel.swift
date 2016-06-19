//
//  BrowserViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseInstanceID

class WebBrowserViewModel:NSObject {

    var router:WebBrowserViewModelRouter?
    
    private var browserModel:WebBrowserModel?
    
    init(browserModel:WebBrowserModel, router:Router?) {
        self.browserModel = browserModel;
        self.router = router;
    }
    
    func checkUserLoggedIn() {
        print("checkUserLoggedIn")
        if FIRAuth.auth()?.currentUser == nil {
            self.router?.showLoginView()
        } else {
            checkOldUser()
        }
    }
    
    private func checkOldUser() {
        let serverService = GoandroidServerService()
        if serverService.getToken() == nil {
            try!FIRAuth.auth()?.signOut()
            self.router?.showLoginView()
        }
    }
    
    // MARK: Push Notifications
    
    func sendFirebaseTokenToServer() {
        if FIRInstanceID.instanceID().token() != nil {
            print("InstanceID token: \(FIRInstanceID.instanceID().token())")
            // Connect to FCM since connection may have failed when attempted before having a token.
            let serverService = GoandroidServerService()
            serverService.postDeviceToken(FIRInstanceID.instanceID().token()!)
        }
    }
    
    func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
}
