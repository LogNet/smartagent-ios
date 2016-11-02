//
//  StringExtension.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 9/8/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

extension String {
    static func isEmpty(string:String?) -> Bool {
        guard string != nil else { return true}
        return string!.characters.count == 0
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}