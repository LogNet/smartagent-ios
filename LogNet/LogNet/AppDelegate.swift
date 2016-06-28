//
//  AppDelegate.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/16/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
import FirebaseAuth
import FirebaseInstanceID
import PKHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: Router?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        // Add observer for InstanceID token refresh callback.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotification),
                                                         name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        Fabric.with([Crashlytics.self])
        configureViewController()
        return true
    }

    // MARK: Firebase
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
//        sendDeviceTokenToServer()
        FIRMessaging.messaging().subscribeToTopic("/topics/smart_agent")
        connectToFcm()
    }
    
    // MARK: Private Methods
    
//    func sendDeviceTokenToServer() {
//        if FIRInstanceID.instanceID().token() != nil {
//            print("InstanceID token: \(FIRInstanceID.instanceID().token())")
//            // Connect to FCM since connection may have failed when attempted before having a token.
////            let serverService = GoandroidServerService()
////            serverService.postDeviceToken(FIRInstanceID.instanceID().token()!)
//        }
//    }
    
    func configureViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.router = Router(navigationController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    // MARK: UIApplicationDelegate
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        print("Push notification info: \(userInfo)")
        // Print full message.
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        print("link = %@", userInfo["link"])
        if application.applicationState == UIApplicationState.Active {
            
            if let aps = userInfo["aps"] {
                if let alert = aps["alert"] {
                     let alertViewModel = AlertNotificationViewModel()
                    alertViewModel.title = alert!["title"] as? String
                    alertViewModel.text = alert!["body"] as? String
                    if let link:String = userInfo["link"] as? String {
                        alertViewModel.urlString = link
                    }
                    self.router?.showNotificationAlert(alertViewModel)
                }
            }
        } else {
            if let link:String = userInfo["link"] as? String {
                self.router?.openURLString(link)
            }
        }
        completionHandler(.NewData)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        } else {
            self.router?.pushNotificationRegistrationCancelled()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .Unknown)
        let refreshedToken = FIRInstanceID.instanceID().token()
        PushTokenUtil.storePushToken(refreshedToken)
        self.router?.loginProceedWithDeviceToken(tokenString)
        print("Device Token:", tokenString)
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    // MARK: Application Lifecycle
    
//    func applicationWillResignActive(application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    }

    func applicationDidEnterBackground(application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

//    func applicationWillEnterForeground(application: UIApplication) {
//        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    }

    func applicationDidBecomeActive(application: UIApplication) {
        connectToFcm()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

//    func applicationWillTerminate(application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }


}

