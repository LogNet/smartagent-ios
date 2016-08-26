//
//  CreatorCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class PNRCellViewModel {
    var id:String?
    var pcc:String?
    var creator:String?
    let model:PNR
    
    init(model:PNR) {
        self.model = model
        self.prepareViewModel()
    }
    
    func prepareViewModel(){
        self.id = self.model.id
        self.pcc = self.model.pcc
        self.creator = self.model.creator
    }
}