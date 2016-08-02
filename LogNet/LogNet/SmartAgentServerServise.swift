//
//  SmartAgentServerServise.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class SmartAgentServerServise: ServerService {
    
    let baseURLString = "http://62.90.233.18:8080/"
    
    func register(phoneNumber: String, first_name: String,
               last_name: String, email: String, uuid: String) -> Observable<String> {
        return Observable.create({[weak self] (observer) -> Disposable in
                let parameters =
                        ["device_number":phoneNumber,
                                 "email":email,
                           "mac_address":uuid,
                            "first_name":first_name,
                             "last_name":last_name]
                let request = Alamofire.request(.POST, self!.baseURLString + "registerDevice",parameters:parameters).responseJSON {response in
                    if response.result.error == nil {
                        if let token = self!.parseToken(response.result.value) {
                            observer.onNext(token)
                            observer.onCompleted()
                        } else {
                            let error = NSError(domain: "lognet.LogNet.SmartAgentServerService", code: -6123, userInfo: [NSLocalizedDescriptionKey: "Token can't be parsed."])
                            observer.onError(error)
                        }
                    } else {
                        observer.onError(response.result.error!)
                    }
                }
            return AnonymousDisposable {
                request.cancel()
            }
        })
    }
    
    private func parseToken(JSON:AnyObject?) -> String? {
        if let token = JSON?["registration_token"] as? String {
            return token
        }
        return nil
    }
    
    func getNotificationList(type: NotificationType, subtype: String?, from_id: Int?, to_id: Int?, from_time: NSTimeInterval?, to_time: NSTimeInterval?, chunks_size: Int?, completion: JSONCompletionBlock?) {
        if (completion != nil) {
            completion!(self.JSONFromBundle(self.JSONNameForType(type)),nil)
        }
    }
    
    func JSONFromBundle(name: String) -> AnyObject? {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        let data = NSData(contentsOfFile: path!)
        let JSON =  try! NSJSONSerialization.JSONObjectWithData(data!, options:.MutableContainers)
        return JSON
    }
    
    
    
    func JSONNameForType(type:NotificationType) -> String {
        var name:String?
        switch type {
        case .Reprice:
            name = "reprice"
            break
        case .Cancelled:
            name = "cancelled"
            break
        case .TicketDue:
            name = "ticketdue"
            break
        default:
            name = "recent"
        }
        return name!
    }

}
