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
    
    let model:PNRInfoModel
    
    init(model: PNRInfoModel,router: Router) {
        self.model = model
        super.init(router: router)
    }
    
    func fetchPNRInfo(notification_id:String) -> Observable<PNRInfo> {
        return self.model.getPNRInfo(notification_id)
    }
}