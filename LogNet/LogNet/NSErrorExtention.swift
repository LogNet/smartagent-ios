//
//  NSErrorExtention.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/7/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

extension NSError {
    class func unknownError(doman:String) -> NSError {
        return NSError(domain: doman, code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."])
    }
}