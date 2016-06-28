//
//  ViewController.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/16/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import ReactiveCocoa
import QuartzCore
import PKHUD

extension CALayer {
    func setBorderColorFromUIColor(color:UIColor) {
        self.borderColor = color.CGColor
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    
    var loginViewModel: LoginViewModel?
    var loginningNow = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bindViewModel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Methods
    
    func bindViewModel() {
/*
        weak var weakSelf = self
        let validPhoneSignal = self.phoneTextField.rac_textSignal().map { (next:AnyObject!) -> AnyObject! in
            let text = next as! String
            return weakSelf!.isValidPhoneString(text)
        }
*/
        self.phoneTextField.rac_textSignal().subscribeNext { (next:AnyObject!) in
            if let text = next as? String {
                self.loginViewModel?.phoneNumber = text
            }
        }
    }
    
    func isValidPhoneString(phoneString:String?) -> Bool {
        if phoneString != nil {
            return phoneString?.characters.count > 0
        }
        return false
    }
    
    func wrongPhoneNumber() {
        let alert =
            UIAlertController(title: "Wrong phone number!",
                              message: "Please, write a valid phone number.",
                              preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
   
    func loginCompletedWithError(error:NSError?) {
        if error == nil {
            HUD.flash(.Success, delay: 1)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            HUD.hide()
            let alert =
                UIAlertController(title: "An error occurred!",
                                  message: "Something went wrong.",
                                  preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func registerForPushNotifications() {
        let application = UIApplication.sharedApplication()
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func pushPermissionsDenied() {
        HUD.hide()
        self.loginningNow = false;
        let alert =
            UIAlertController(title: "Push notifications denied.",
                              message: "Go to Settings->Notifications and enable it.",
                              preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startLogin()  {
        self.registerForPushNotifications()
    }
    
    // MARK: IBActions
    
    func proceedWithToken() {
        weak var weakSelf = self
        self.loginningNow = false
        self.loginViewModel?.deviceToken = PushTokenUtil.getPushToken()
        if loginViewModel?.deviceToken != nil {
            self.loginViewModel?.login({ (error) in
                weakSelf?.loginCompletedWithError(error)
            })
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        if self.isValidPhoneString(self.phoneTextField.text) {
            self.phoneTextField.resignFirstResponder()
            self.loginningNow = true;
            self.startLogin()
            HUD.show(.SystemActivity)
        } else {
            self.wrongPhoneNumber()
        }
    }
    
}
