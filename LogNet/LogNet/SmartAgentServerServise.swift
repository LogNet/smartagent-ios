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
    
    let baseURLString = "https://www.lognet-smartagent.com/"
    
    private lazy var manager : Alamofire.Manager = {
        // Create the server trust policies
        let manager = Alamofire.Manager.sharedInstance

        if let cookie = self.getCookie() {
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
            manager.session.configuration.HTTPCookieStorage?.setCookie(cookie)
        }
        
//        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
//            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
//            var credential: NSURLCredential?
//            
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
//                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
//                print(credential)
//            } else {
//                if challenge.previousFailureCount > 0 {
//                    disposition = .CancelAuthenticationChallenge
//                } else {
//                    credential = manager.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
//                    
//                    if credential != nil {
//                        disposition = .UseCredential
//                    }
//                }
//            }
//            
//            return (disposition, credential)
//        }
        
        return manager
    }()
    
    func deleteNotification(phoneNumber:String, token:String, notification_id:String) -> Observable<Void>{
        return Observable.create{ observer in
            let headers = ["SA-DN":phoneNumber, "SA-REGID":token]
            let parameters = ["notification_id":notification_id]
            self.manager.request(.DELETE,self.baseURLString + "deleteNotifications",
                parameters: parameters, headers: headers).responseJSON(completionHandler: { response in
                    print("deleted notification response error \(response)")
                    if response.result.error == nil {
                        observer.onNext()
                        observer.onCompleted()
                    } else {
                        observer.onError(response.result.error!)
                    }
                })
            return AnonymousDisposable {
            }
        }

    }

    
    func register(phoneNumber: String, first_name: String,
               last_name: String, email: String, uuid: String) -> Observable<String> {
        return Observable.create({(observer) -> Disposable in
                let parameters =
                        ["device_number":phoneNumber,
                                 "email":email,
                           "mac_address":uuid,
                            "first_name":first_name,
                             "last_name":last_name]
                let request = Alamofire.request(.POST, self.baseURLString + "registerDevice", parameters:parameters).responseJSON {response in
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
    
    func sendNotificationToken(notificationToken: String, phone: String, registrationToken: String) -> Observable<Void> {
        return Observable.create{ observer in
            let headers = ["SA-DN":phone, "SA-REGID":registrationToken]
            let parameters = ["device_number":phone,
            "registration_token":registrationToken,
            "notification_token":notificationToken]
            self.manager.request(.POST,self.baseURLString + "setNotificationToken",
                parameters: parameters, headers: headers).responseJSON(completionHandler: { response in
                    print(response.response?.statusCode)
            })
            return AnonymousDisposable {
            }
        }
    }
    
    func getNotificationList(phoneNumber phoneNumber:String,
                                               token:String,
                                                type:String?,
                                             subtype:String?,
                                              offset:Int?,
                                         chunks_size:Int?) -> Observable<AnyObject> {
        return Observable.create({ observer -> Disposable in
            let parameters = ["type":self.validParameter(type),
                           "subtype":self.validParameter(subtype),
                            "offset":self.validParameter(offset),
                             "chunk":self.validParameter(chunks_size)]
            let headers = ["SA-DN":phoneNumber, "SA-REGID":token]
            let request = self.manager.request(.GET, self.baseURLString + "getNotificationList",
                                            parameters: parameters, headers: headers)
                
                // TODO: Create function for all methods to avoid code duplication.
                .responseJSON(completionHandler: { response in
                    if response.result.error == nil {
                        let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(response.response?.allHeaderFields as! [String: String], forURL: (response.response?.URL!)!)
                        
                        //Save method.
                        if let cookie = cookies.first {
                            self.setCookie(cookie)
                            self.manager.session.configuration.HTTPCookieStorage?.setCookie(cookie)
                        }
                        if response.result.value != nil {
                            observer.onNext(response.result.value!)
                            observer.onCompleted()
                        } else {
                             let error = NSError(domain: "lognet.LogNet.SmartAgentServerService",
                                                 code: -6123,
                                             userInfo: [NSLocalizedDescriptionKey: "Server response is nil."])
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
    
    func getNotificationData(phoneNumber:String, token:String, notification_id:String) -> Observable<AnyObject> {
        return Observable.create { observer in
            let parameters = ["notification_id":notification_id]
            let headers = ["SA-DN":phoneNumber, "SA-REGID":token]
            let request = self.manager.request(.GET, self.baseURLString + "getNotificationData",
                parameters: parameters, headers: headers)
            .responseJSON(completionHandler: { response in
                
                // TODO: Create function for all methods to avoid code duplication.
                if response.result.error == nil {
                    if response.result.value != nil {
                        observer.onNext(response.result.value!)
                        observer.onCompleted()
                    } else {
                        let error = NSError(domain: "lognet.LogNet.SmartAgentServerService",
                            code: -6123,
                            userInfo: [NSLocalizedDescriptionKey: "Server response is nil."])
                        observer.onError(error)
                    }
                } else {
                    observer.onError(response.result.error!)
                }
            })
            return AnonymousDisposable {
                request.cancel()
            }
            
        }
    }

    private func setCookie (cookie:NSHTTPCookie) {
        NSUserDefaults.standardUserDefaults().setObject(cookie.properties, forKey: "kCookie")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func getCookie () -> NSHTTPCookie? {
        var cookie:NSHTTPCookie?
        if let properties = NSUserDefaults.standardUserDefaults().objectForKey("kCookie") as? [String : AnyObject] {
            cookie = NSHTTPCookie(properties: properties)
        }
        return cookie
    }
    
    private func parseToken(JSON:AnyObject?) -> String? {
        if let token = JSON?["registration_token"] as? String {
            return token
        }
        return nil
    }
    
    private func validParameter(parameter:AnyObject?) -> AnyObject {
        guard parameter != nil else {
            return ""
        }
        return parameter!
    }
}
