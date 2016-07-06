//
//  ViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit

class Router {
    private weak var loginViewController:LoginViewController?
    private var navigationController:UINavigationController?
    private var storyboard:UIStoryboard
    
    init(_ navigationController:UINavigationController){
        self.navigationController = navigationController
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.setupHomeViewController()
    }
   
    func setupHomeViewController() {
        let notificationsViewController = self.storyboard.instantiateViewControllerWithIdentifier("RecentViewController") as! RecentViewController
        let model = RecentModelFactory.getSmartAgentRecentModel()
        let notificationsViewModel = RecentViewModel(model: model, router: self)
        notificationsViewController.viewModel = notificationsViewModel;
        self.navigationController!.viewControllers = [notificationsViewController]
    }
    
    func showLoginView() {
        let loginViewController = self.getLoginViewController()
        let homeViewController = self.navigationController!.viewControllers[0]
        homeViewController.presentViewController(loginViewController, animated: false, completion: nil)
    }
    
    func getLoginViewController() -> UIViewController {
        let loginModel = LoginModelsFactory.getLoginModel()
        let loginViewModel = LoginViewModel(loginModel: loginModel,router: self)
        let loginViewController:LoginViewController =
            self.storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginViewController.loginViewModel = loginViewModel;
        self.loginViewController = loginViewController
        loginViewModel.router = self
        return loginViewController;
    }
    
    func loginFinished() {
        self.registerForPushNotifications()
        let notificationsViewController =
                self.navigationController!.viewControllers[0] as! RecentViewController
        notificationsViewController.fetch()
    }
    
    func showNotificationAlert(alertViewModel:AlertNotificationViewModel)  {
            let alert =
                UIAlertController(title: alertViewModel.title,
                                  message: alertViewModel.text,
                                  preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil);
            let open = UIAlertAction(title: "Open", style: .Default) { (action:UIAlertAction) in
                self.openURLString(alertViewModel.urlString!)
            }
            
            alert.addAction(open)
            alert.addAction(cancel)
            self.navigationController?.topViewController!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openURLString(urlString:String) {
        let browserViewController = self.storyboard.instantiateViewControllerWithIdentifier("WebBrouserViewController") as? WebBrouserViewController
        let model = WebBrowserModel()
        let viewModel = WebBrowserViewModel(browserModel: model, router: self)
        viewModel.urlString = urlString
        browserViewController?.viewModel = viewModel
        self.navigationController?.pushViewController(browserViewController!, animated: true)
    }
    
    func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()
        let notificationSettings =
                UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
}