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

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var loginViewModel: LoginViewModel?
    var loginningNow = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.bindViewModel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Methods
    
    func bindViewModel() {
        // Observe name.
        self.phoneTextField.rac_textSignal().subscribeNext { (next:AnyObject!) in
            if let text = next as? String {
                self.loginViewModel?.phoneNumber = text
            }
        }
        // Observe name.
        self.nameTextField.rac_textSignal().subscribeNext { (next:AnyObject!) in
            if let text = next as? String {
                self.loginViewModel?.name = text
            }
        }
    }
    
    func isValidPhoneString(phoneString:String?) -> Bool {
        if phoneString != nil {
            return phoneString?.characters.count > 0
        }
        return false
    }
    
    func isValidName(name:String?) -> Bool {
        if name != nil {
            return name?.characters.count > 0
        }
        return false
    }
    
    func wrongRegistrationFields() {
        if !self.isValidName(nameTextField.text) {
            self.wrongName()
        } else {
            self.wrongPhoneNumber()
        }
    }
    
    func wrongPhoneNumber() {
        let alert =
            UIAlertController(title: "Wrong phone number!",
                              message: "Please, write a valid phone number.",
                              preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    func wrongName() {
        let alert =
            UIAlertController(title: "Wrong name!",
                              message: "Please, write a valid name.",
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
    
    func pushPermissionsDenied() {
        HUD.hide()
        self.loginningNow = false;
        let alert =
            UIAlertController(title: "Push notifications disabled.",
                              message: "Go to Settings->Notifications and enable it.",
                              preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startLogin()  {
        self.loginViewModel?.login({ [weak self] (error) in
            self?.loginCompletedWithError(error)
        })
    }
    
// MARK: IBActions
    
    @IBAction func login(sender: AnyObject) {
        if self.isValidPhoneString(self.phoneTextField.text) && self.isValidName(self.nameTextField.text) {
            self.phoneTextField.resignFirstResponder()
            self.nameTextField.resignFirstResponder()
            self.startLogin()
            HUD.show(.SystemActivity)
        } else {
            self.wrongRegistrationFields()
        }
    }
    
}
