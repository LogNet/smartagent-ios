//
//  AlertCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class AlertCellViewModel {
    var text:String? {
        get {
            return self.model.text
        }
    }
    
    var code:String? {
        get {
            return self.model.code
        }
    }
    
    private let model:Alert
    
    init(model:Alert) {
        self.model = model
    }
    
}