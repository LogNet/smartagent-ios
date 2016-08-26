//
//  PassengerCellVIewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class PassengerCellVIewModel {
    var title:String?
    var first_name:String?
    var last_name:String?
    var type:String?
    let model:Passenger
    
    init (model:Passenger) {
        self.model = model
        self.prepareViewModel()
    }
    
    func prepareViewModel(){
        self.title = self.model.title
        self.first_name = self.model.first_name
        self.last_name = self.model.last_name
        self.type = self.model.last_name
    }
    
}