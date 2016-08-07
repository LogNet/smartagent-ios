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
    case Unknown
}


class ErrorUtil {
    class func ErrorWithMessage(message:String) -> ErrorType {
        switch message {
        case "NOT_ACTIVATED":
            return ApplicationError.NOT_ACTIVATED
        case "FORBIDDEN":
            return ApplicationError.FORBIDDEN
        default:
            return ApplicationError.Unknown
        }
    }
}