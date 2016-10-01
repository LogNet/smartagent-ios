//
//  PNRInfoViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

class PNRInfoViewModel: ViewModel {
    private let model:PNRInfoModel
    private let notification_id:String
    private var shareText:String?
    private let disposableBag = DisposeBag()
    private var contactNumber:String?
    let hasActiveAction = Variable(false)
    var unreadNotificationsModel:UnreadMessagesInfoModel!
    var contentProvider:PNRContentProvider!
    
    init(model: PNRInfoModel,notification_id:String, router: Router) {
        self.notification_id = notification_id
        self.model = model
        self.unreadNotificationsModel = UnreadMessagesInfoModel(apiFacade: self.model.apiFacade)
        self.unreadNotificationsModel.parser = self.model.serverParser
        super.init(router: router)
    }
    
    // MARK: Public methods
    
    func reprice() -> Observable<Void> {
        return self.model.executePendingOperation(self.notification_id, action: PNROperationAction.Reprice).flatMap{ result in
            self.parseInfo(result)
        }
    }
    
    func keepRepricing() -> Observable<Void> {
        let info = self.contentProvider.results.value?.first as! (PNRInfo, Notification)
        let notification = info.1
        let action = notification.typeStatus == TypeStatus.INACTIVE.rawValue ? PNROperationAction.ContinueRepricing : PNROperationAction.StopRepricing
        return self.model.executePendingOperation(self.notification_id, action: action).flatMap { result in
            self.parseInfo(result)
        }
    }
    
    func callToContact() {
        if let phone = self.contactNumber {
            if let url = NSURL(string: "tel://\(phone)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    func fetchPNRInfo() -> Observable<Void> {
        self.unreadNotificationsModel.getUnreadMessages().subscribeNext { [weak self] info in
            self?.router.showUnreadNotificationsBages(info)
        }.addDisposableTo(self.disposableBag)
        
        return self.model.getPNRInfo(self.notification_id).flatMap{ (pnrInfo, notification) in
            self.parseInfo((pnrInfo, notification))
        }
    }
    
    func getShareText() -> String? {
        return self.shareText
    }
    
    // MARK: Private methods
    
    private func parseInfo(info:(PNRInfo, Notification)) -> Observable<Void> {
        self.contentProvider.results.value = [info]
        if  let phone = info.0.contact?.phone {
            self.contactNumber = phone
        }
        self.shareText = info.1.getShareText()
        self.hasActiveAction.value = info.1.type == "RP"
        return Observable.just()
    }
}