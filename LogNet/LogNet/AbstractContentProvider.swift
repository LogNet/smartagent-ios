//
//  AbstractContentProvider.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Realm


class AbstractContentProvider: NSObject {
    private let realm = try! Realm()
    let listType:ListType
    let subtype:NotificationSubtype

    lazy var notifications:Results<Notification> = {
        let results = self.realm.objects(Notification.self).filter( self.subtype.rawValue == "" ? "listType == '\(self.listType.rawValue)'" : "listType = '\(self.listType.rawValue)' AND sub_type == '\(self.subtype.rawValue)'")
        return results
    }()
    
    init(listType:ListType, subtype: NotificationSubtype) {
        self.listType = listType
        self.subtype = subtype
    }
    
    func cellViewModelForRow(row:Int) -> RecentNotificationCellViewModel {
        let notification = notifications[row]
        return self.viewModelFromNotification(notification)
    }
    
    private func viewModelFromNotification(notification:Notification) -> RecentNotificationCellViewModel {
        let viewModel = RecentNotificationCellViewModel(notification: notification)
        return viewModel
    }
}
