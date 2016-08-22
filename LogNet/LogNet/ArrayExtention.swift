//
//  ArrayExtention.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}