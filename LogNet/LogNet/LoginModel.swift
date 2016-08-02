//
//  LoginModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import FirebaseAuth
import KeychainAccess

class LoginModel {
    let UUID_KEY = "UUID_KEY"
    var parser:ServerParser?
    
    private var apiFacade: APIFacade
    
    init (apiFacade:APIFacade) {
        self.apiFacade = apiFacade
    }
    
    // MARK: Public methods
    
    class func isUserLoggedIn() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
    }
    
    func login(phoneNumber:String, full_name:String, email:String, completed: (NSError?)->Void) {
        let uuid = self.getUUID()
        let array = full_name.characters.split{$0 == " "}.map(String.init)
        let first_name = array[0] as String
        let last_name = array[1] as String
        
        self.apiFacade.register(phoneNumber, first_name: first_name,
                           last_name: last_name, email: email, uuid: uuid)
    }
    
    // MARK: Private methods
    
    private func getUUID() -> String  {
        let keychain = Keychain()
        guard (keychain[UUID_KEY] != nil) else {
            let uuid = NSUUID().UUIDString
            keychain[UUID_KEY] = uuid
            return uuid
        }
        return keychain[UUID_KEY]!
    }
    
}