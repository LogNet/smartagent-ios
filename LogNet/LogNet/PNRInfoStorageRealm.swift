//
//  PNRInfoStorageRealm.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class PNRInfoStorageRealm: RealmStorage, AbstractPNRInfoStorage {
    
    override init() {
        super.init()
        self.saveQueue = dispatch_queue_create("com.lognet.pnr_info.queue", DISPATCH_QUEUE_SERIAL)
    }
    
    func addPNFInfo(pnrInfo:PNRInfo, completion: ErrorCompletionBlock?) {
        
        // TODO Needs refactoring. Instead to crating a new object, should use write transactions.
        let pnr = pnrInfo.copy() as! PNRInfo
        self.addObject(pnr, update: true, completion: completion)
    }
    
    func getPNFInfo(notification_id:String) throws -> PNRInfo? {
        let realm = try Realm()
        realm.refresh()
        let pnrInfos = realm.objects(PNRInfo.self).filter("notification_id == '\(notification_id)'")
        return pnrInfos.first
    }
}