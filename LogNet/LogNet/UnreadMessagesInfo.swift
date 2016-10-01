//
//  UnreadMessagesModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 9/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RealmSwift

class UnreadMessagesInfo: Object {
    dynamic var total:String?
    dynamic var ticketingDue:String?
    dynamic var reprice:String?
    dynamic var cancelled:String?
}
