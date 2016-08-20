//
//  RealmStorage.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStorage {
    
    var saveQueue: dispatch_queue_t!
    
    // MARK: Private
    
    internal func addRealmObject(object: Object) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(object)
        try! realm.commitWrite()
    }
    
    func addObject(object: Object, completion: ErrorCompletionBlock?) {
        dispatch_async(self.saveQueue!) {
            autoreleasepool({
                self.addRealmObject(object)
            })
        }
    }
    
    func addObjects(objects: [Object], completion: ErrorCompletionBlock?) {
        dispatch_async(self.saveQueue!) {
            autoreleasepool({
                for object in objects {
                    self.addRealmObject(object)
                }
                if completion != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion!(error: nil)
                    })
                }
            })
        }
    }
}