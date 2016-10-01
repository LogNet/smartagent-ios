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
    
    internal func addRealmObject(object: Object, update:Bool) throws {
        let realm = try Realm()
        realm.beginWrite()
        realm.add(object, update: update)
        try realm.commitWrite()
    }
    
    func addObject(object: Object, update: Bool, completion: ErrorCompletionBlock?) {
        dispatch_async(self.saveQueue!) {
            autoreleasepool({
                do {
                    try self.addRealmObject(object,update: update)
                } catch let error as NSError {
                    if completion != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            completion!(error: error)
                        })
                    }
                }
            })
            if completion != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    completion!(error: nil)
                })
            }
        }
    }
    
    func addObjects(objects: [Object], update: Bool, completion: ErrorCompletionBlock?) {
        dispatch_async(self.saveQueue!) {
            autoreleasepool({
                for object in objects {
                    try! self.addRealmObject(object, update: update)
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