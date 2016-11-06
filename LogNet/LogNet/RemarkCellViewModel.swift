//
//  RemarkCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class RemarkCellViewModel {
    
    var text:String? {
        get {
            return self.model.text
        }
    }
    
    private let model:Remark
    
    init(model:Remark) {
        self.model = model
    }
}
