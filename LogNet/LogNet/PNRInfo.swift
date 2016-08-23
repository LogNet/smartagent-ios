//
//  PNRInfo.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RealmSwift

class PNRInfo: Object {
    dynamic var notificaion_id:String!
    
    override static func primaryKey() -> String? {
        return "notificaion_id"
    }
}
