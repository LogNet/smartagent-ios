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
    dynamic var id:String?
    dynamic var pcc:String?
    dynamic var creator:String?
}

class Contact: Object {
    dynamic var name:String?
    dynamic var phone:String?
    dynamic var email:String?
}

class Passenger: Object {
    dynamic var title:String?
    dynamic var first_name:String?
    dynamic var last_name:String?
    dynamic var type:String?
}

class Flight: Object {
    dynamic var from:String?
    dynamic var to:String?
    dynamic var departure:String?
    dynamic var arrival:String?
    dynamic var flight_number:String?
    dynamic var flight_class:String?
    dynamic var status:String?
}

class Hotel: Object {
    dynamic var country:String?
    dynamic var city:String?
    dynamic var hotel_name:String?
    dynamic var status:String?
    dynamic var start:String?
    dynamic var end:String?
    dynamic var duration:String?
    dynamic var room_type:String?
    dynamic var cost:String?
}

class Car: Object {
    dynamic var pickup_city:String?
    dynamic var pickup_date:String?
    dynamic var return_date:String?
    dynamic var car_type:String?
    dynamic var amount:String?
    dynamic var vendor:String?
}


class PNRInfo: Object {
    dynamic var type:String?
    dynamic var notification_id:String?
    dynamic var title:String?
    dynamic var pnr:PNR!
    dynamic var contact:Contact!
    dynamic var shareText:String?

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
        pnrInfo.title = self.title
        pnrInfo.type = self.type
        pnrInfo.notification_id = self.notification_id
        pnrInfo.pnr = self.pnr
        pnrInfo.contact = self.contact
        pnrInfo.passengers.appendContentsOf(self.passengers)
        pnrInfo.hotels.appendContentsOf(self.hotels)
        pnrInfo.cars.appendContentsOf(self.cars)
        pnrInfo.flights.appendContentsOf(self.flights)
        pnrInfo.shareText = self.shareText
        return pnrInfo
    }
    
    override static func primaryKey() -> String? {
        return "notification_id"
    }
}
