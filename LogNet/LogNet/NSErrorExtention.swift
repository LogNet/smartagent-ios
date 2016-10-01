//
//  NSErrorExtention.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/7/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//
import Crashlytics
import Foundation

extension NSError {
    class func unknownError(doman:String) -> NSError {
        return NSError(domain: doman, code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."])
    }
    
    class func error(message message:String, doman:String) -> NSError {
        return NSError(domain: doman, code: 0, userInfo: [NSLocalizedDescriptionKey:message])
    }
    
    func logToCrashlytics() {
        Crashlytics.sharedInstance().recordError(self)
    }
    
    class func logError(dict:[String:AnyObject]) {
        let error = NSError(domain: "com.lognet.SmartAgent_iOS", code: 0, userInfo: [NSLocalizedDescriptionKey : dict])
        error.logToCrashlytics()
    }
}

extension ErrorType {
    func logToCrashlytics() {
        let error = self as NSError
        error.logToCrashlytics()
    }
}
