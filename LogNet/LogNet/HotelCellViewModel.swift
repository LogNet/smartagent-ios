//
//  HotelCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class HotelCellViewModel {
    var country:String?
    var city:String?
    var hotel_name:String?
    var status:String?
    var start:String?
    var end:String?
    var duration:String?
    var room_type:String?
    var cost:String?
    let model:Hotel

    
    init (model:Hotel) {
        self.model = model
        self.prepareViewModel()
    }
    
    func prepareViewModel(){
        self.country = self.model.country
        self.city = self.model.city
        self.hotel_name = self.model.hotel_name
        self.status = self.model.status
        self.start = self.model.start
        self.end = self.model.end
        self.duration = self.model.duration
        self.room_type = self.model.room_type
        self.cost = self.model.cost
    }
    
}