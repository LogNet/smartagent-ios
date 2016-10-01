//
//  PNRInfoStorage.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol AbstractPNRInfoStorage {
    
    func addPNFInfo(pnrInfo:PNRInfo, completion: ErrorCompletionBlock?)
    func getPNFInfo(notification_id:String) throws -> PNRInfo?
}