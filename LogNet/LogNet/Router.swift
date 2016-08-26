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
    private weak var recentViewController:SingleListViewController?
    private var tabBarController:UITabBarController
    private var storyboard:UIStoryboard
    
    init(_ tabBarController:UITabBarController){
        self.tabBarController = tabBarController
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.setupHomeViewController()
        self.setupTicketingDueViewControler()
        self.setupRepriceViewController()
        self.setupCancelledViewController()
    }
   
    func setupTicketingDueViewControler() {
        let navigationController = self.tabBarController.viewControllers?.last as? UINavigationController
        let recentViewController = navigationController?.viewControllers.first as? SingleListViewController
        let model = ListModelFactory.getSingleListModel()
        let notificationsViewModel = SingleListViewModel.ticketingDueViewModel(model, router: self)
        recentViewController!.viewModel = notificationsViewModel;
        recentViewController?.dataSource = NotificationDataSource()
    }
    
    func setupHomeViewController() {
        let navigationController = self.tabBarController.viewControllers?.first as? UINavigationController
        let recentViewController = navigationController?.viewControllers.first as? SingleListViewController
        let model = ListModelFactory.getSingleListModel()
        let notificationsViewModel = SingleListViewModel.recentViewModel(model, router: self)
        recentViewController!.viewModel = notificationsViewModel;
        recentViewController?.dataSource = RecentDataSource()
        self.recentViewController = recentViewController
    }
    
    func setupRepriceViewController() {
        let navigationController = self.tabBarController.viewControllers?[1] as? UINavigationController
        let splitListsViewController = navigationController?.viewControllers.first as? SplitListsViewController
        // TODO: Needs refactoring
        splitListsViewController?.router = self
        
        // TODO: Needs refactoring
        // Pending view controller
        let model = ListModelFactory.getSingleListModel()
        let notificationsViewModel = SingleListViewModel.repriceViewModel(model, subtype: .Pending, router: self)
        splitListsViewController?.pendingViewModel = notificationsViewModel
        splitListsViewController?.pendingDataSource = NotificationDataSource()

        // TODO: Needs refactoring
        // Completed view controller
        let model2 = ListModelFactory.getSingleListModel()
        let notificationsViewModel2 = SingleListViewModel.repriceViewModel(model2, subtype: .Complete, router: self)

        splitListsViewController?.completedViewModel = notificationsViewModel2
        splitListsViewController?.completedDataSource = NotificationDataSource()
    }
    
    func setupCancelledViewController() {
        let navigationController = self.tabBarController.viewControllers?[2] as? UINavigationController
        let splitListsViewController = navigationController?.viewControllers.first as? SplitListsViewController
        
        // TODO: Needs refactoring
        splitListsViewController?.router = self
        
        // TODO: Needs refactoring
        // Pending view controller
        let model = ListModelFactory.getSingleListModel()
        let notificationsViewModel = SingleListViewModel.cancelledViewModel(model, subtype: .Pending, router: self)
        splitListsViewController?.pendingViewModel = notificationsViewModel
        splitListsViewController?.pendingDataSource = NotificationDataSource()
        
        // TODO: Needs refactoring
        // Completed view controller
        let model2 = ListModelFactory.getSingleListModel()
        let notificationsViewModel2 = SingleListViewModel.cancelledViewModel(model2, subtype: .Complete, router: self)
        
        splitListsViewController?.completedViewModel = notificationsViewModel2
        splitListsViewController?.completedDataSource = NotificationDataSource()
        
        //        recentViewController!.viewModel = notificationsViewModel;
        //        recentViewController?.dataSource = TicketingDueDataSource()
    }
    
    func showSearchView() {
        let model = SearchModel()
        model.storageService = NotificationsStorageRealm()
        model.searchHistoryStorage = SearchHistoryStorageRealm()
        let viewModel = SearchViewModel(model: model, router: self)
        viewModel.contentProvider = SearchContentProvider()
        let searchViewController = self.storyboard.instantiateViewControllerWithIdentifier("SearchTableViewController") as! SearchTableViewController
        searchViewController.dataSource = SearchHistoryDataSource()
        searchViewController.viewModel = viewModel
        let navigationController = self.tabBarController.selectedViewController as? UINavigationController
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    func showLoginView() {
        let loginViewController = self.getLoginViewController()
        self.recentViewController?.presentViewController(loginViewController, animated: false, completion: nil)
    }
    
    func showNoActivatedView() {
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("ActivationMessageViewController") as! ActivationMessageViewController
        let model = ListModelFactory.getSingleListModel()
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
    
    func showPNRDetailsFromNotification(notification: Notification) {
        let model = PNRInfoModel()
        model.serverParser = SmartAgentParser()
        model.apiFacade = APIFacade(service: SmartAgentServerServise())
        model.storageService = PNRInfoStorageRealm()
        let viewModel = PNRInfoViewModel(model: model,notification_id:notification.notification_id!, router: self)
        viewModel.contentProvider = PNRContentProvider()
        let navigationController = self.tabBarController.selectedViewController as! UINavigationController
        let pnrViewController = self.storyboard.instantiateViewControllerWithIdentifier("RepricePNRView") as! RepricePNRView
        pnrViewController.viewModel = viewModel
        navigationController.pushViewController(pnrViewController, animated: true)
    }
}