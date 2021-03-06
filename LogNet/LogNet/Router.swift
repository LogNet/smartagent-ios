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
    private weak var ticketingDueViewController:SingleListViewController?
    private weak var repriceViewController:SplitListsViewController?
    private weak var cancelledViewController:SplitListsViewController?

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
   
    func showUnreadNotificationsBages(unreadNotificationsInfo:UnreadMessagesInfo) {
        self.repriceViewController?.navigationController?.tabBarItem.badgeValue = unreadNotificationsInfo.reprice
        self.ticketingDueViewController?.navigationController?.tabBarItem.badgeValue = unreadNotificationsInfo.ticketingDue
        self.recentViewController?.navigationController?.tabBarItem.badgeValue = unreadNotificationsInfo.total
        self.cancelledViewController?.navigationController?.tabBarItem.badgeValue = unreadNotificationsInfo.cancelled
        guard let total = unreadNotificationsInfo.total else {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            return
        }
        guard let unread = Int(total) else {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
            return
        }
        UIApplication.sharedApplication().applicationIconBadgeNumber = unread
    }
    
    func setupTicketingDueViewControler() {
        let navigationController = self.tabBarController.viewControllers?.last as? UINavigationController
        let ticketingDueViewController = navigationController?.viewControllers.first as? SingleListViewController
        let model = ListModelFactory.getSingleListModel()
        let notificationsViewModel = SingleListViewModel.ticketingDueViewModel(model, router: self)
        ticketingDueViewController!.viewModel = notificationsViewModel;
        ticketingDueViewController?.dataSource = NotificationDataSource()
        self.ticketingDueViewController = ticketingDueViewController
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
        splitListsViewController?.listType = ListType.Reprice
        
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
        self.repriceViewController = splitListsViewController
    }
    
    func setupCancelledViewController() {
        let navigationController = self.tabBarController.viewControllers?[2] as? UINavigationController
        let splitListsViewController = navigationController?.viewControllers.first as? SplitListsViewController
        
        // TODO: Needs refactoring
        splitListsViewController?.router = self
        splitListsViewController?.listType = ListType.Cancelled

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
        self.cancelledViewController = splitListsViewController
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
    
    func checkTerms() {
        if Prefences.termsApproved() == true || Prefences.getToken() == nil {
            return
        }
        
        let viewController = self.storyboard.instantiateViewControllerWithIdentifier("TermsViewController") as! TermsViewController
        viewController.viewModel = self.recentViewController?.viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        self.recentViewController?.presentViewController(navigationController, animated: false, completion: nil)
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

        }
            
            alert.addAction(open)
            alert.addAction(cancel)
    }
    
    
    func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()
        let notificationSettings =
                UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func openPNRFromRemouteNotification(notification_id: String) {
        self.tabBarController.selectedIndex = 0
        let navigationController = self.tabBarController.selectedViewController as! UINavigationController
        let pnrViewController = self.storyboard.instantiateViewControllerWithIdentifier("PNRInfoViewController") as! PNRInfoViewController
        pnrViewController.viewModel = self.getPNRViewModel(notification_id)
        pnrViewController.dataSource = PNRDataSource()
        navigationController.pushViewController(pnrViewController, animated: true)
    }
    
    func showPNRDetails(notification_id: String) {
        let navigationController = self.tabBarController.selectedViewController as! UINavigationController
        let pnrViewController = self.storyboard.instantiateViewControllerWithIdentifier("PNRInfoViewController") as! PNRInfoViewController
        pnrViewController.viewModel = self.getPNRViewModel(notification_id)
        pnrViewController.dataSource = PNRDataSource()
        navigationController.pushViewController(pnrViewController, animated: true)
    }
    
    // MARK: Private
    
    private func getPNRViewModel(notification_id: String) -> PNRInfoViewModel {
        let model = PNRInfoModel()
        model.serverParser = SmartAgentParser()
        model.apiFacade = APIFacade(service: SmartAgentServerServise())
        model.pnrStorageService = PNRInfoStorageRealm()
        model.notificationStorageService = NotificationsStorageRealm()
        let viewModel = PNRInfoViewModel(model: model,notification_id:notification_id, router: self)
        viewModel.contentProvider = PNRContentProvider()
        return viewModel
    }
    
}