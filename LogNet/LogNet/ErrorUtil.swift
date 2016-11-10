//
//  ErrorUtil.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/7/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation


enum ApplicationError:ErrorType {
    case FORBIDDEN
    case NOT_ACTIVATED
    case NoInternetConnection
    case Server
    case Unknown
    
    func getError() -> NSError {
        switch self {
        case .FORBIDDEN:
            return NSError(domain: APPLICATION_DOMAIN, code: 0, userInfo: [NSLocalizedDescriptionKey : "Forbiden access."])
        case .NOT_ACTIVATED:
            return NSError(domain: APPLICATION_DOMAIN, code: 0, userInfo: [NSLocalizedDescriptionKey : "Account not activated."])
        case .NoInternetConnection:
            return NSError(domain: APPLICATION_DOMAIN, code: 0, userInfo: [NSLocalizedDescriptionKey : "No internet connection."])
        case .Server:
            return NSError(domain: APPLICATION_DOMAIN, code: 0, userInfo: [NSLocalizedDescriptionKey : "Server error. Please try again later."])
        default:
            return NSError(domain: APPLICATION_DOMAIN, code: 0, userInfo: [NSLocalizedDescriptionKey : "Unknown error."])
        }
    }
}

class ErrorUtil {
    class func ErrorWithMessage(message:String) -> ErrorType {
        switch message {
        case "NOT_ACTIVATED":
            return ApplicationError.NOT_ACTIVATED.getError()
        case "FORBIDDEN":
            return ApplicationError.FORBIDDEN.getError()
        case "SERVER_ERROR":
            return ApplicationError.Server.getError()
        default:
            return ApplicationError.Unknown.getError()
        }
    }
}