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
    var contentProvider:PNRContentProvider!
    let disposableBag = DisposeBag()
    
    init(model: PNRInfoModel,notification_id:String, router: Router) {
        self.notification_id = notification_id
        self.model = model
        super.init(router: router)
    }
    
    func fetchPNRInfo() {
        self.model.getPNRInfo(self.notification_id).subscribeNext{ pnrInfo in
            self.contentProvider.results.value = [pnrInfo]
        }.addDisposableTo(self.disposableBag)
    }
    
}