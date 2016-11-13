//
//  UIViewControllerExtention.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 9/1/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert (error:ErrorType?, action:((UIAlertAction) -> Void)? ) {
        var message = "Something went wrong!"
        
        //TODO: Needs refactoring
        if error != nil {
            switch error! {
            case ApplicationError.Server:
                message = ApplicationError.Server.getError().localizedDescription
                break
            case ApplicationError.FORBIDDEN:
                message = ApplicationError.Server.getError().localizedDescription
                break
            case ApplicationError.Unknown:
                message = ApplicationError.Server.getError().localizedDescription
                break
            case ApplicationError.NOT_ACTIVATED:
                message = ApplicationError.Server.getError().localizedDescription
                break
            case ApplicationError.NoInternetConnection:
                message = ApplicationError.Server.getError().localizedDescription
                break
            default:
                let ns_error = error as! NSError
                if ns_error.code == -1009 {
                    message = "No internet connection!"
                }
                
                if let ns_error = error as? NSError {
                    message = ns_error.localizedDescription
                }
            }
            
        }
        
        let alert =
            UIAlertController(title: "An error occured.",
                              message: message,
                              preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:action))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func shareText(text:String) {
        // Analytics.
        AppAnalytics.logEvent(Events.ACTION_SHARE)
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            self.navigationController?.presentViewController(activityViewController, animated: true) {
            // ...
        }
    }
}