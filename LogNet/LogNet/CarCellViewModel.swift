//
//  CarCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class CarCellViewModel {
    var pickup_city:String?
    var pickup_date:String?
    var return_date:String?
    var car_type:String?
    var amount:String?
    var vendor:String?
    let model:Car

    init (model:Car) {
        self.model = model
        self.prepareViewModel()
    }
    
    func prepareViewModel(){
        self.pickup_city = self.model.pickup_city
        self.pickup_date = self.model.pickup_date
        self.return_date = self.model.return_date
        self.car_type = self.model.car_type
        self.amount = self.model.amount
        self.vendor = self.model.vendor
    }
}