//
//  ContainerViewController.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/12/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

let SequeIdentifierPending = "embedPending"
let SequeIdentifierCompleted = "embedCompleted"

class EmptySegue: UIStoryboardSegue {
    override func perform() { }
}

class ContainerViewController: UIViewController {
   
    //TODO: Needs refactoring
    var pendingViewController:SingleListViewController!
    var completedViewController:SingleListViewController!
    var currentSegueIdentifier:String! = SequeIdentifierPending
    var transitionInProgress:Bool! = false
    
    //TODO: Needs refactoring
    var pendingViewModel:SingleListViewModel!
    var completedViewModel:SingleListViewModel!
    var pendingDataSource:AbstractDataSource!
    var completedDataSource:AbstractDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchViewController(fromViewController: UIViewController, toViewController: UIViewController){
        toViewController.view.frame = self.view.bounds
        fromViewController.willMoveToParentViewController(nil)
        self.addChildViewController(toViewController)
        self.transitionFromViewController(fromViewController, toViewController: toViewController, duration: 0.2, options: .TransitionCrossDissolve, animations: nil) { finished in
            fromViewController.removeFromParentViewController()
            toViewController.didMoveToParentViewController(self)
            self.transitionInProgress = false
        }
    }
    
    func switchViewControllers(){
        print("View controllers switched.")
        if self.transitionInProgress.boolValue {
            return
        }
        
        self.transitionInProgress = true
        self.currentSegueIdentifier =
            (self.currentSegueIdentifier == SequeIdentifierPending)
            ? SequeIdentifierCompleted :SequeIdentifierPending
        if self.currentSegueIdentifier ==  SequeIdentifierPending && self.pendingViewController != nil {
            self.switchViewController(self.completedViewController, toViewController: self.pendingViewController)
            return
        }
        
        if self.currentSegueIdentifier ==  SequeIdentifierCompleted && self.completedViewController != nil {
            self.switchViewController(self.pendingViewController, toViewController: self.completedViewController)
            return
        }
        
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SequeIdentifierPending {
            self.pendingViewController = segue.destinationViewController as! SingleListViewController
            self.pendingViewController.viewModel = self.pendingViewModel
            self.pendingViewController.dataSource = self.pendingDataSource
        }
        
        if segue.identifier == SequeIdentifierCompleted {
            self.completedViewController = segue.destinationViewController as! SingleListViewController
            self.completedViewController.viewModel = self.completedViewModel
            self.completedViewController.dataSource = self.completedDataSource
        }
        
        if segue.identifier == SequeIdentifierPending {
            if self.childViewControllers.count > 0 {
                self.switchViewController(self.childViewControllers[0], toViewController: self.pendingViewController)
            } else {
                self.addChildViewController(segue.destinationViewController)
                let view = segue.destinationViewController.view
                view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                view.frame = self.view.bounds
                self.view.addSubview(view)
                segue.destinationViewController.didMoveToParentViewController(self)
            }
        } else if segue.identifier == SequeIdentifierCompleted {
            self.switchViewController(self.childViewControllers[0], toViewController: self.completedViewController)
        }
        
    }

    
    
}
