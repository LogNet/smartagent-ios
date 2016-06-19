//
//  ViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewModelRouter {
    func loginFinished()
}

protocol WebBrowserViewModelRouter {
    func showLoginView()
}

class Router:WebBrowserViewModelRouter,LoginViewModelRouter {
    
    private var navigationController:UINavigationController?
    
    init(_ navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func showLoginView() {
        let loginViewController = self.getLoginViewController()
        let browserViewController = self.navigationController!.viewControllers[0] as! WebBrouserViewController
        browserViewController.presentViewController(loginViewController, animated: false, completion: nil)
    }
    
    func getLoginViewController() -> UIViewController {
        let loginModel = LoginModelsFactory.getLoginModel()
        let loginViewModel = LoginViewModel(loginModel: loginModel,router: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController:LoginViewController =
            storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        loginViewController.loginViewModel = loginViewModel;
        loginViewModel.router = self
        return loginViewController;
    }
    
    func loginFinished() {
        let browserViewController = self.navigationController!.viewControllers[0] as! WebBrouserViewController
        browserViewController.viewModel?.registerForPushNotifications()
        browserViewController.viewModel?.sendFirebaseTokenToServer()
        
    }
}