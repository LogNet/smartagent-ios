//
//  ActivationMessageViewController.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift

class ActivationMessageViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    
    var viewModel:ActivationViewModel?
    private let disposableBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Smart Agent"
        self.bindViewModel()
        self.subscribeToNotificationCenter()
        
        // Analytics.
        AppAnalytics.logEvent(Events.SCREEN_NOT_ACTIVATED)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func subscribeToNotificationCenter() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                       name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    private func bindViewModel() {
        self.emailLabel.text = viewModel?.email
    }

    func applicationDidBecomeActive() {
        self.viewModel?.isUserActivated().subscribeNext{ [weak self] activated in
            self?.viewModel?.sendNotificationToken()
            self?.dismissViewControllerAnimated(true, completion: nil)
            }.addDisposableTo(self.disposableBag)
    }
    
    // MARK: - @IBAction
    
    @IBAction func resetCredentials(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.viewModel?.resetCredentials()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
}
