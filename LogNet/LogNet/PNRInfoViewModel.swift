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
    
    init(model: PNRInfoModel,notification_id:String, router: Router) {
        self.notification_id = notification_id
        self.model = model
        super.init(router: router)
    }
    
    func fetchPNRInfo() -> Observable<Void> {
        return self.model.getPNRInfo(self.notification_id).flatMap{ pnrInfo in
            return self.fillPNRInfo(pnrInfo)
        }
    }
    
    func fillPNRInfo(pnrInfo:PNRInfo) -> Observable<Void> {
        return Observable.create { observer in
            return AnonymousDisposable{}
        }
    }
}