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
    private let notification:Notification
    var contentProvider:PNRContentProvider!
    let disposableBag = DisposeBag()
    
    init(model: PNRInfoModel,notification:Notification, router: Router) {
        self.notification = notification
        self.model = model
        super.init(router: router)
    }
    
    func fetchPNRInfo() -> Observable<Void> {
        return self.model.getPNRInfo(self.notification.notification_id!).flatMap{ pnrInfo in
            self.parsePnrInfo(pnrInfo)
        }
    }
    
    func parsePnrInfo(pnrInfo:PNRInfo) -> Observable<Void> {
        self.contentProvider.results.value = [pnrInfo]
        return Observable.just()
    }
    
    func getShareText() -> String {
        return self.notification.getShareText()
    }
}