//
//  PNRInfo.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import RealmSwift

class PNR: Object {
    var id:String?
    var pcc:String?
    var creator:String?
}

class Contact: Object {
    var name:String?
    var phone:String?
    var email:String?
}

class Passenger: Object {
    var title:String?
    var first_name:String?
    var last_name:String?
    var type:String?
}

class Flight: Object {
    var from:String?
    var to:String?
    var departure:String?
    var arrival:String?
    var flight_number:String?
    var flight_class:String?
    var status:String?
}

class Hotel: Object {
    var country:String?
    var city:String?
    var hotel_name:String?
    var status:String?
    var start:String?
    var end:String?
    var duration:String?
    var room_type:String?
    var cost:String?
}

class Car: Object {
    var pickup_city:String?
    var pickup_date:String?
    var return_date:String?
    var car_type:String?
    var amount:String?
    var vendor:String?
}


class PNRInfo: Object {
    dynamic var notification_id:String?
    dynamic var pnr:PNR!
    dynamic var contact:Contact!
    let passengers = List<Passenger>()
    let flights = List<Flight>()
    let hotels = List<Hotel>()
    let cars = List<Car>()

    func setPassengers(passengers:[Passenger]?) {
        guard passengers != nil else { return }
        self.passengers.appendContentsOf(passengers!)
        print(self.passengers)
    }
    
    func setFlights(flights:[Flight]?) {
        guard flights != nil else { return }
        self.flights.appendContentsOf(flights!)
    }
    
    func setCars(cars:[Car]?) {
        guard cars != nil else { return }
        self.cars.appendContentsOf(cars!)
    }
    
    func setHotels(hotels:[Hotel]?) {
        guard hotels != nil else { return }
        self.hotels.appendContentsOf(hotels!)
    }
    
    override func copy() -> AnyObject {
        let pnrInfo = PNRInfo()
        pnrInfo.notification_id = self.notification_id
        pnrInfo.pnr = self.pnr
        pnrInfo.contact = self.contact
        pnrInfo.passengers.appendContentsOf(self.passengers)
        pnrInfo.hotels.appendContentsOf(self.hotels)
        pnrInfo.cars.appendContentsOf(self.cars)
        pnrInfo.flights.appendContentsOf(self.flights)
        return pnrInfo
    }
    
    override static func primaryKey() -> String? {
        return "notification_id"
    }
}
