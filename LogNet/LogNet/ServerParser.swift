//
//  ServerParser.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol ServerParser {
    func parseToken(JSON:AnyObject?) -> String?
    func parseNotifications(JSON:AnyObject?, listType:ListType) -> (array:Array<Notification>?, error:ErrorType?)
    func parsePNRInfo(JSON:AnyObject) -> (pnrInfo:PNRInfo?, ErrorType?)
}