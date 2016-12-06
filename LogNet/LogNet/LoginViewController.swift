//
//  ViewController.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/16/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import QuartzCore
import PKHUD
import RxSwift
import MRCountryPicker

extension CALayer {
    func setBorderColorFromUIColor(color:UIColor) {
        self.borderColor = color.CGColor
    }
}

class LoginViewController: UIViewController, MRCountryPickerDelegate, UITextFieldDelegate {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryPicker: MRCountryPicker!
    
    private var isPhoneValid = false
    var loginViewModel: LoginViewModel?
    var loginningNow = false;
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.bindViewModel()
        self.addCountryPicker()
        
        // Analytics.
        AppAnalytics.logEvent(Events.SCREEN_LOGIN)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Methods
    
    func setDefaultHost() {
        let alertController = UIAlertController(title: "Server settings", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "URL"
        }
        
        let action = UIAlertAction(title: "Set", style: .Default) { action in
            let urlTextField = alertController.textFields![0] as UITextField
            self.loginViewModel?.changeDefaultURL(urlTextField.text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let qa_action = UIAlertAction(title: "Use QA", style: .Default) { action in
            self.loginViewModel?.changeDefaultURL("https://sapre.sabre.co.il:8443/")
        }
        alertController.addAction(action)
        alertController.addAction(qa_action)
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addCountryPicker() {
        self.countryPicker.countryPickerDelegate = self
        self.countryPicker.showPhoneNumbers = true
        self.countryPicker.setCountry("IL")
    }
    
    func bindViewModel() {
        // Observe phone number.
        self.phoneTextField.rx_text.subscribeNext { (text) in
            var phone = text
            if !String.isEmpty(phone) {
                let leadCharacterIndex = text.startIndex.advancedBy(0)
                let leadCharacter = text[leadCharacterIndex]
                if leadCharacter == "0" {
                    phone = String(text.characters.dropFirst())
                }
            }
            let phoneLength = 9
            self.isPhoneValid = phone.characters.count == phoneLength
            self.loginViewModel?.phoneNumber = self.codeLabel.text! + phone
            print(self.loginViewModel?.phoneNumber)
        }.addDisposableTo(self.disposeBag)
        
        // Observe name.
        self.nameTextField.rx_text.subscribeNext { (text) in
            self.loginViewModel?.full_name = text
        }.addDisposableTo(self.disposeBag)

        // Observe email.
        self.emailTextField.rx_text.subscribeNext { (text) in
            self.loginViewModel?.email = text
        }.addDisposableTo(self.disposeBag)
        
        self.loginViewModel?.canSetHost.asObservable().subscribeNext { canSet in
            if canSet == true {
                self.setDefaultHost()
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    func isValidPhoneString() -> Bool {
        return self.isPhoneValid
    }
    
    func isValidName() -> Bool {
        if self.loginViewModel?.full_name != nil {
            return self.loginViewModel?.full_name?.characters.count > 0
        }
        return false
    }
    
    func isValidEmail() -> Bool {
        if self.loginViewModel?.email != nil {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluateWithObject(self.loginViewModel?.email)
        }
        return false
    }
    
    func wrongEmail(){
        let alert =
            UIAlertController(title: "Wrong email!",
                              message: "Please, write a valid email.",
                              preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func wrongRegistrationFields() {
        if !self.isValidName() {
            self.wrongName()
        } else if !self.isValidPhoneString() {
            self.wrongPhoneNumber()
        } else {
            self.wrongEmail()
        }
    }
    
    func isValidAllFields() -> Bool {
        if self.isValidPhoneString() && self.isValidName() && self.isValidEmail() {
            return true
        }
        self.wrongRegistrationFields()
        return false
    }
    
    func loginCompletedWithError(error:NSError?) {
        if error == nil {
            HUD.flash(.Success, delay: 1)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            HUD.hide()
            self.showErrorAlert(error, action: nil)
            error?.logToCrashlytics()
        }
    }
    
    func pushPermissionsDenied() {
        HUD.hide()
        self.loginningNow = false;
        let alert =
            UIAlertController(title: "Push notifications disabled.",
                              message: "Go to Settings -> Notifications and enable it.",
                              preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startLogin()  {
        // Analytics.
        AppAnalytics.logEvent(Events.ACTION_LOGIN)
        
        self.loginViewModel?.login({ [weak self] (error) in
            self?.loginCompletedWithError(error)
        })
    }
    
    func hideKeyboard(){
        self.phoneTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
    }
    
    // MARK: IBActions
    
    @IBAction func tapHostSetter(sender: AnyObject) {
       self.loginViewModel?.clickToSetHost()
    }
    
    @IBAction func showCountries(sender: AnyObject) {
        if self.countryPicker.hidden {
            self.countryPicker.hidden = false
            self.hideKeyboard()
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        if self.isValidAllFields() {
            self.hideKeyboard()
            self.startLogin()
            HUD.show(.SystemActivity)
        }
    }
    
    // MARK: Text field delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.countryPicker.hidden = true
        return true
    }

    
    // MARK: MRCountryPickerDelegate
    
    func countryPhoneCodePicker(picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.codeLabel.text = phoneCode
        if let text = self.phoneTextField.text {
            self.loginViewModel?.phoneNumber = phoneCode + text
        }
    }
}
