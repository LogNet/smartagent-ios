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
    
    private var navigationController:UINavigationController?
    private var storyboard:UIStoryboard
    
    init(_ navigationController:UINavigationController){
        self.navigationController = navigationController
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.setupHomeViewController()
    }
   
    func setupHomeViewController() {
        let notificationsViewController = self.storyboard.instantiateViewControllerWithIdentifier("NotificationsTableViewController") as! NotificationsTableViewController
        let model = NotificationsModelFactory.getGoandroidNotificationsModel()
        let notificationsViewModel = NotificatonsViewModel(model: model, router: self)
        notificationsViewController.viewModel = notificationsViewModel;
        self.navigationController!.viewControllers = [notificationsViewController]

       /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let browserViewController = storyboard.instantiateViewControllerWithIdentifier("WebBrouserViewController") as!WebBrouserViewController
        let webBrowserModel = WebBrowserModel()
        let webBrowserViewModel = WebBrowserViewModel(browserModel: webBrowserModel, router: self)
        browserViewController.viewModel = webBrowserViewModel
        self.navigationController!.viewControllers = [browserViewController]
        */
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
        loginViewModel.router = self
        return loginViewController;
    }
    
    func loginFinished() {
        let notificationsViewController = self.navigationController!.viewControllers[0] as! NotificationsTableViewController
        notificationsViewController.viewModel?.registerForPushNotifications()
        notificationsViewController.viewModel?.sendFirebaseTokenToServer()        
    }
    
    func showNotificationAlert(viewModel:AlertNotificationViewModel) {
        let browserViewController = self.navigationController!.viewControllers[0] as! WebBrouserViewController
        browserViewController.showNotificationAlert(viewModel)
    }
    
    func openURLString(urlString:String) {
        let browserViewController = self.storyboard.instantiateViewControllerWithIdentifier("WebBrouserViewController") as? WebBrouserViewController
        let model = WebBrowserModel()
        let viewModel = WebBrowserViewModel(browserModel: model, router: self)
        viewModel.urlString = urlString
        browserViewController?.viewModel = viewModel
        self.navigationController?.pushViewController(browserViewController!, animated: true)
    }
}