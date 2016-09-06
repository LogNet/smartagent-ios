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
    
    var contentProvider:PNRContentProvider!
    
    init(model: PNRInfoModel,notification_id:String, router: Router) {
        self.notification_id = notification_id
        self.model = model
        super.init(router: router)
    }
    
    // MARK: Public methods
    
    func callToContact() {
        if let phone = self.contactNumber {
            if let url = NSURL(string: "tel://\(phone)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    func fetchPNRInfo() -> Observable<Void> {
        return self.model.getPNRInfo(self.notification_id).flatMap{ pnrInfo in
            self.parsePnrInfo(pnrInfo)
        }
    }
    
    func getShareText() -> String? {
        return self.shareText
    }
    
    // MARK: Private methods
    
    private func parsePnrInfo(pnrInfo:PNRInfo) -> Observable<Void> {
        self.contentProvider.results.value = [pnrInfo]
        self.contactNumber = pnrInfo.contact.phone
        self.shareText = pnrInfo.shareText
        return Observable.just()
    }
}