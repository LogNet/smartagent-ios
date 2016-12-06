//
//  FlightCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class FlightCellViewModel {
    var from:String?
    var to:String?
    var departure:String?
    var arrival:String?
    var flight_number:String?
    var flight_class:String?
    var status:String?
    let model:Flight
    
    init (model:Flight) {
        self.model = model
        self.prepareViewModel()
    }
    
    func prepareViewModel(){
        self.from = self.model.from
        self.to = self.model.to
        self.departure = self.model.departure
        self.arrival = self.model.arrival
        if self.model.flight_number != nil && self.model.airline != nil {
            self.flight_number = "\(self.model.airline!)\(self.model.flight_number!)"
        } else {
            self.flight_number = self.model.flight_number!

        }
        self.flight_class = self.model.flight_class
        self.status = self.model.status
    }
    
}
