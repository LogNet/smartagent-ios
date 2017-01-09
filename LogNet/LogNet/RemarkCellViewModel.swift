//
//  RemarkCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

// Needs to rename this class.
class RemarkCellViewModel {
    
    var text:String? {
        get {
            if let text = self.model.getTextValue() {
                return "Class \(text)"
            }
            return nil
        }
    }
    
    private let model:TextModel
    
    init(model:TextModel) {
        self.model = model
    }
}
