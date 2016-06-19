//
//  GoandroidServerParser.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class GoandroidServerParser: ServerParser {
    func parseToken(JSON: AnyObject?) -> String? {
        if JSON != nil {
            let token = JSON!["token"] as! String
            return token
        }
        return nil
    }
}