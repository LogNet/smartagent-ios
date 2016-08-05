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
        return Observable.create({(observer) -> Disposable in
                let parameters =
                        ["device_number":phoneNumber,
                                 "email":email,
                           "mac_address":uuid,
                            "first_name":first_name,
                             "last_name":last_name]
                let request = Alamofire.request(.POST, self.baseURLString + "registerDevice",parameters:parameters).responseJSON {response in
                    if response.result.error == nil {
                        if let token = self.parseToken(response.result.value) {
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
    
    func getNotificationList(authHeaders:AuthHeaders,
                                    type:String?,
                                 subtype:String?,
                                 offset:Int?,
                             chunks_size:Int?) -> Observable<AnyObject> {
        return Observable.create({ observer -> Disposable in
            let parameters = ["type":self.validParameter(type),
                           "subtype":self.validParameter(subtype),
                            "offset":self.validParameter(offset),
                             "chunk":self.validParameter(chunks_size)]
            let headers = ["SA-DN":authHeaders.phoneNumber,
                        "SA-REGID":authHeaders.token]
            let request = Alamofire.request(.GET, self.baseURLString + "getNotificationList",
                                            parameters: parameters, headers: headers)
                .responseJSON(completionHandler: { response in
                    if response.result.error == nil {
                        if response.result.value != nil {
                            observer.onNext(response.result.value!)
                            observer.onCompleted()
                        } else {
                             let error = NSError(domain: "lognet.LogNet.SmartAgentServerService", code: -6123, userInfo: [NSLocalizedDescriptionKey: "Server response is nil."])
                            observer.onError(error)
                        }
                    } else {
                        observer.onError(response.result.error!)
                    }
                })
            
            return AnonymousDisposable {
                request.cancel()
            }
        })
    }
    
    private func validParameter(parameter:AnyObject?) -> AnyObject {
        guard parameter != nil else {
            return ""
        }
        return parameter!
    }
}
