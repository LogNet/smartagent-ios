
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
    
    func parseUnreadMessagesInfo(JSON: AnyObject) -> (UnreadMessagesInfo?, ErrorType?) {
        guard let dict = JSON as? [String:Int] else {
            if let error = self.checkOnErrorStatus(JSON){
                return (nil, error)
            } else {
                return (nil, ApplicationError.Unknown)
            }
        }
        let unreadMessagesInfo = UnreadMessagesInfo()
        
        if let count = dict["RP"] {
            if count != 0 {
                unreadMessagesInfo.reprice = String(count)
            }
        }
        
        if let count = dict["TD"] {
            if count != 0 {
                unreadMessagesInfo.ticketingDue = String(count)
            }
        }
        
        if let count = dict["C"] {
            if count != 0 {
                unreadMessagesInfo.cancelled = String(count)
            }
        }
        
        if let count = dict["total"] {
            if count != 0 {
                unreadMessagesInfo.total = String(count)
            }
        }
        return (unreadMessagesInfo, nil)
    }
    
    func parsePNRInfo(JSON:AnyObject) -> (result:(PNRInfo?, Notification?), ErrorType?) {
        print(JSON)
        let pnrInfo = PNRInfo()
        
        if let jsonDict = JSON["data"] as? [String: AnyObject] {
            pnrInfo.pnr = self.parsePNR(jsonDict["pnr"] as? Dictionary)
            pnrInfo.contact = self.parseContact(jsonDict["contact"] as? Dictionary)
            pnrInfo.setPassengers(self.parsePassengers(jsonDict["passengers"] as? Array))
            pnrInfo.setFlights(self.parseFlights(jsonDict["flights"] as? Array))
            pnrInfo.setHotels(self.parseHotels(jsonDict["hotels"] as? Array))
            pnrInfo.setCars(self.parseCars(jsonDict["cars"] as? Array))
        } else {
            pnrInfo.isValid = false
        }
        
        if let payloadDict = JSON["payload"] as? [String: AnyObject] {
            pnrInfo.setAlerts(self.parseAlerts(payloadDict["alerts"] as? Array))
            pnrInfo.setRemarks(self.parseRemarks(payloadDict["remarks"] as? Array))
            pnrInfo.last_purchase_date = self.parseLastPurchaseDate(payloadDict["last_purchase_date"] as? String)
        }
        
        if let jsonHeaderDict = JSON["header"] as? [String: AnyObject] {
            let notification = self.parseNotificationFormDictionary(jsonHeaderDict)
            return ((pnrInfo, notification), nil)
        }
        
        if let error = self.checkOnErrorStatus(JSON){
            return ((nil, nil), error)
        } else {
            return ((nil, nil), ApplicationError.Unknown)
        }
    }
    
    func parseNotifications(JSON:AnyObject?, listType:ListType) -> (array:Array<Notification>?, error:ErrorType?) {
        print(JSON)
        if let jsonDict = JSON as? [[String: AnyObject]] {
            var notifications = Array<Notification>()
            for jsonNotification in jsonDict {
                if let notification = self.parseNotificationFormDictionary(jsonNotification) {
                    notification.listType = listType.rawValue
                    notifications.append(notification)
                }
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
    
    private func parseNotificationFormDictionary(jsonNotification:[String: AnyObject]) -> Notification? {
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
        notification.typeStatus = jsonNotification["type_status"] as? String
        notification.alert_indicator = jsonNotification["alert_indicator"] as! Bool
        return notification
    }
    
    private func parseLastPurchaseDate(date:String?) -> String? {
        if let dateString = date {
            let alertsDateFormatter = NSDateFormatter()
            alertsDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            if let last_date = self.dateFormatter.dateFromString(dateString) {
                return alertsDateFormatter.stringFromDate(last_date)
            }
        }
        return nil
    }
    
    private func parseAlerts(array:[[String: String]]?) -> [Alert]? {
        guard array != nil else {
            return nil
        }
        var entities:[Alert] = []
        for dict in array! {
            let alert = Alert()
            alert.code = dict["code"]
            alert.text = dict["text"]
            entities.append(alert)
        }
        return entities
    }
    
    private func parseRemarks(array:[String]?) -> [Remark]? {
        guard array != nil else {
            return nil
        }
        var entities:[Remark] = []
        for string in array! {
            let remark = Remark()
            remark.text = string
            entities.append(remark)
        }
        return entities
    }
    
    private func parseCars(array:[[String: String]]?) -> [Car]? {
        guard array != nil else {
            return nil
        }
        let carDateFormatter = NSDateFormatter()
        carDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        var entities:[Car] = []
        for dict in array! {
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
    
    private func parseHotels(array:[[String: String]]?) -> [Hotel]? {
        guard array != nil else {
            return nil
        }
        var entities:[Hotel] = []
        let hotelDateFormatter = NSDateFormatter()
        hotelDateFormatter.dateFormat = "dd.MM.yyyy"
        for dict in array! {
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
    
    private func parseFlights(array:[[String: String]]?) -> [Flight]? {
        guard array != nil else {
            return nil
        }
        let flightDateFormatter = NSDateFormatter()
        flightDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        var entities:[Flight] = []
        for dict in array! {
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
    
    private func parsePassengers(array:[[String: String]]?) -> [Passenger]? {
        guard array != nil else {
            return nil
        }
        var entities:[Passenger] = []
        for dict in array! {
            let passenger = Passenger()
            passenger.title = dict["title"]
            passenger.first_name = dict["first_name"]
            passenger.last_name = dict["last_name"]
            passenger.type = dict["type"]
            entities.append(passenger)
        }
        return entities
    }
    
    private func parseContact(contactDict:[String: String]?) -> Contact? {
        guard contactDict != nil else {
            return nil
        }
        let contact = Contact()
        contact.name = contactDict!["name"]
        contact.phone = contactDict!["phone"]
        contact.email = contactDict!["email"]
        return contact
    }
    
    private func parsePNR(pnrDict:[String: String]?) -> PNR? {
        guard pnrDict != nil else {
            return nil
        }
        let pnr = PNR()
        pnr.id = pnrDict!["id"]
        pnr.pcc = pnrDict!["pcc"]
        pnr.creator = pnrDict!["creator"]
        return pnr
    }
    
    private func checkOnErrorStatus(JSON:AnyObject) -> ErrorType? {
        let jsonDict = JSON as? [String: AnyObject]
        let code = jsonDict?["code"]
        let status = jsonDict?["status"]
        if (code != nil) && (status != nil) {
            if jsonDict != nil {
                NSError.logError(jsonDict!)
            }
            return ErrorUtil.ErrorWithMessage(code as! String)
        }
        return nil
    }
}