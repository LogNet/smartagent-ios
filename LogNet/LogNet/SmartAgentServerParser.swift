//
//  GoandroidServerParser.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class SmartAgentParser: ServerParser {
    
    lazy var dateFormatter:NSDateFormatter = {
       let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'"
        return dateFormatter
    }()
    
    func parseToken(JSON: AnyObject?) -> String? {
        if JSON != nil {
            let token = JSON!["token"] as! String
            return token
        }
        return nil
    }
    
    func parsePNRInfo(JSON:AnyObject) -> (pnrInfo:PNRInfo?, ErrorType?) {
        print(JSON)
        let pnrInfo = PNRInfo()
        if let jsonDict = JSON["data"] as? [String: AnyObject] {
            pnrInfo.pnr = self.parsePNR(jsonDict["pnr"] as! Dictionary)
            pnrInfo.contact = self.parseContact(jsonDict["contact"] as! Dictionary)
            pnrInfo.setPassengers(self.parsePassengers(jsonDict["passengers"] as! Array))
            pnrInfo.setFlights(self.parseFlights(jsonDict["flights"] as! Array))
            pnrInfo.setHotels(self.parseHotels(jsonDict["hotels"] as! Array))
            pnrInfo.setCars(self.parseCars(jsonDict["cars"] as! Array))
        }
        if let jsonHeaderDict = JSON["header"] as? [String: AnyObject] {
            pnrInfo.title = ""
            if let text = jsonHeaderDict["title"] as? String {
                pnrInfo.title = text
            }
            
            if let text = jsonHeaderDict["title_message"] as? String {
                pnrInfo.title = "\(pnrInfo.title!) - \(text)"
            }
            
            if let text = jsonHeaderDict["type"] as? String {
                pnrInfo.type = text
            }
            return (pnrInfo, nil)
        }
        if let error = self.checkOnErrorStatus(JSON){
            return (nil, error)
        } else {
            return (nil, ApplicationError.Unknown)
        }

    }
    
    func parseNotifications(JSON:AnyObject?, listType:ListType) -> (array:Array<Notification>?, error:ErrorType?) {
        print(JSON)
        if let jsonDict = JSON as? [[String: AnyObject]] {
            var notifications = Array<Notification>()
            for jsonNotification in jsonDict {
                let notification = Notification()
                notification.notification_id = jsonNotification["notification_id"] as? String
                notification.status = jsonNotification["status"] as? String
                notification.type = jsonNotification["type"] as? String
                notification.sub_type = jsonNotification["subtype"] as? String
                notification.title = jsonNotification["title"] as? String
                notification.title_message = jsonNotification["title_message"] as? String
                let time = jsonNotification["notification_time"] as? String
                notification.notification_time = self.dateFormatter.dateFromString(time!)
                notification.pnr_summary = jsonNotification["pnr_summary"] as? String
                notification.contact_name = jsonNotification["contact_name"] as? String
                notification.listType = listType.rawValue

                notifications.append(notification)
            }
            return (notifications, nil);
        }
        if let error = self.checkOnErrorStatus(JSON!){
            return (nil, error)
        } else {
            return (nil, ApplicationError.Unknown)
        }

    }
    
    // MARK: Private
    
    private func parseCars(array:[[String: String]]) -> [Car]? {
        let carDateFormatter = NSDateFormatter()
        carDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        var entities:[Car] = []
        for dict in array {
            let car = Car()
            car.pickup_city = dict["pickup_city"]
            if let dateString = dict["pickup_date"]{
                if let date = self.dateFormatter.dateFromString(dateString) {
                    car.pickup_date = carDateFormatter.stringFromDate(date)
                }
            }
            
            if let dateString = dict["return_date"]{
                if let date = self.dateFormatter.dateFromString(dateString) {
                    car.return_date = carDateFormatter.stringFromDate(date)
                }
            }

            car.car_type = dict["car_type"]
            car.amount = dict["amount"]
            car.vendor = dict["vendor"]
            entities.append(car)
        }
        return entities
    }
    
    private func parseHotels(array:[[String: String]]) -> [Hotel]? {
        var entities:[Hotel] = []
        let hotelDateFormatter = NSDateFormatter()
        hotelDateFormatter.dateFormat = "dd.MM.yyyy"
        for dict in array {
            let hotel = Hotel()
            hotel.country = dict["country"]
            hotel.city = dict["city"]
            hotel.hotel_name = dict["hotel_name"]
            hotel.status = dict["status"]
            if let dateString = dict["start"]{
                if let date = self.dateFormatter.dateFromString(dateString) {
                    hotel.start = hotelDateFormatter.stringFromDate(date)
                }
            }
            if let dateString = dict["end"]{
                if let date = self.dateFormatter.dateFromString(dateString) {
                    hotel.end = hotelDateFormatter.stringFromDate(date)
                }
            }
            hotel.duration = dict["duration"]
            hotel.room_type = dict["room_type"]
            hotel.cost = dict["cost"]
            entities.append(hotel)
        }
        return entities
    }
    
    private func parseFlights(array:[[String: String]]) -> [Flight]? {
        let flightDateFormatter = NSDateFormatter()
        flightDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        var entities:[Flight] = []
        for dict in array {
            let flight = Flight()
            flight.from = dict["from"]
            flight.to = dict["to"]
            if let dateString = dict["departure"]{
                if let date = self.dateFormatter.dateFromString(dateString) {
                    flight.departure = flightDateFormatter.stringFromDate(date)
                }
            }
            if let dateString = dict["arrival"]{
                if let date = self.dateFormatter.dateFromString(dateString) {
                    flight.arrival = flightDateFormatter.stringFromDate(date)
                }
            }
            flight.flight_number = dict["flight_number"]
            flight.flight_class = dict["flight_class"]
            flight.status = dict["status"]
            entities.append(flight)
        }
        return entities
    }
    
    private func parsePassengers(array:[[String: String]]) -> [Passenger]? {
        var entities:[Passenger] = []
        for dict in array {
            let passenger = Passenger()
            passenger.title = dict["title"]
            passenger.first_name = dict["first_name"]
            passenger.last_name = dict["last_name"]
            passenger.type = dict["type"]
            entities.append(passenger)
        }
        return entities
    }
    
    private func parseContact(contactDict:[String: String]) -> Contact {
        let contact = Contact()
        contact.name = contactDict["name"]
        contact.phone = contactDict["phone"]
        contact.email = contactDict["email"]
        return contact
    }
    
    private func parsePNR(pnrDict:[String: String]) -> PNR {
        let pnr = PNR()
        pnr.id = pnrDict["id"]
        pnr.pcc = pnrDict["pcc"]
        pnr.creator = pnrDict["creator"]
        return pnr
    }
    
    private func checkOnErrorStatus(JSON:AnyObject) -> ErrorType? {
        let jsonDict = JSON as? [String: AnyObject]
        let code = jsonDict?["code"]
        let status = jsonDict?["status"]
        if (code != nil) && (status != nil) {
            return ErrorUtil.ErrorWithMessage(code as! String)
        }
        return nil
    }
}