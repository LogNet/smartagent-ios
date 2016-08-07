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
    private weak var recentViewController:RecentViewController?
    private var tabBarController:UITabBarController
    private var storyboard:UIStoryboard
    
    init(_ tabBarController:UITabBarController){
        self.tabBarController = tabBarController
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.setupHomeViewController()
    }
   
    func setupHomeViewController() {
        let navigationController = self.tabBarController.viewControllers?.first as? UINavigationController
        let recentViewController = navigationController?.viewControllers.first as? RecentViewController
        let model = RecentModelFactory.getSmartAgentRecentModel()
        let notificationsViewModel = RecentViewModel(model: model, router: self)
        recentViewController!.viewModel = notificationsViewModel;
        self.recentViewController = recentViewController
    }
    
    func showLoginView() {
        let loginViewController = self.getLoginViewController()
        self.recentViewController?.presentViewController(loginViewController, animated: false, completion: nil)
    }
    
    func showNoActivatedView() {
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("ActivationMessageViewController") as! ActivationMessageViewController
        let model = RecentModelFactory.getSmartAgentRecentModel()
        let viewModel = ActivationViewModel(model: model)
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        self.recentViewController?.presentViewController(navigationController, animated: false, completion: nil)
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
        self.recentViewController?.fetch()
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
    }
    
    func openURLString(urlString:String) {
        let browserViewController = self.storyboard.instantiateViewControllerWithIdentifier("WebBrouserViewController") as? WebBrouserViewController
        let model = WebBrowserModel()
        let viewModel = WebBrowserViewModel(browserModel: model, router: self)
        viewModel.urlString = urlString
        browserViewController?.viewModel = viewModel
    }
    
    func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()
        let notificationSettings =
                UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func showPNRDetailsFromNotification(notification: Notification?) {
        let navigationController = self.tabBarController.selectedViewController as! UINavigationController
        let pnrViewController = self.storyboard.instantiateViewControllerWithIdentifier("RepricePNRView")
        navigationController.pushViewController(pnrViewController, animated: true)
    }
}