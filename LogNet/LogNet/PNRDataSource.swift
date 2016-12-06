//
//  PNRDataSource.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PNRDataSource: BaseRXDataSource, UITableViewDelegate {
    var statusCellViewModel:StatusCellViewModel?
    var pnrCellViewModel:PNRCellViewModel?
    var passengers:[PassengerCellViewModel]?
    var flights:[FlightCellViewModel]?
    var hotels:[HotelCellViewModel]?
    var cars:[CarCellViewModel]?
    var type:String?
    var contactCellViewModel:ContactCellViewModel?
    var typeStatus:String?
    var alerts:[AlertCellViewModel]?
    var remarks:[RemarkCellViewModel]?
    var segmentClasses:[RemarkCellViewModel]?

    var latestPurchaseDateCellViewModel:LatestPurchaseCellViewModel?
    
    override func subscribeToProvider (){
        self.contentProvider.results.asObservable().subscribeNext { object in
            if let info = object?.first as? (PNRInfo, Notification) {
                self.parsePNRInfo(info)
                self.tableView.reloadData()
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    // MARK: - Private
    
    private func parsePNRInfo(info:(PNRInfo, Notification)) {
        let pnrInfo = info.0
        let notification = info.1
        let statusCellModel = StatusCellViewModel(title: notification.getUITitle())
        statusCellModel.keepRepricing = info.1.typeStatus == TypeStatus.ACTIVE.rawValue
        self.statusCellViewModel = statusCellModel
        if let pnr = pnrInfo.pnr {
            self.pnrCellViewModel = PNRCellViewModel(model: pnr)
        }
        if let contact = pnrInfo.contact {
            self.contactCellViewModel = ContactCellViewModel(model: contact)
        }
        
        self.type = notification.type
        // Passengers.
        self.passengers = [PassengerCellViewModel]()
        for passenger in pnrInfo.passengers {
            self.passengers?.append(PassengerCellViewModel(model: passenger))
        }
        
        // Flights.
        self.flights = [FlightCellViewModel]()
        for flight in pnrInfo.flights {
            self.flights?.append(FlightCellViewModel(model: flight))
        }
        
        // Passengers.
        self.hotels = [HotelCellViewModel]()
        for hotel in pnrInfo.hotels {
            self.hotels?.append(HotelCellViewModel(model: hotel))
        }
        
        // Passengers.
        self.cars = [CarCellViewModel]()
        for car in pnrInfo.cars {
            self.cars?.append(CarCellViewModel(model: car))
        }
        
        self.alerts = [AlertCellViewModel]()
        for alert in pnrInfo.alerts {
            self.alerts?.append(AlertCellViewModel(model: alert))
        }
        
        self.remarks = [RemarkCellViewModel]()
        for remark in pnrInfo.remarks {
            self.remarks?.append(RemarkCellViewModel(model: remark))
        }
        
        self.segmentClasses = [RemarkCellViewModel]()
        for segment in pnrInfo.segmentClasses {
            self.segmentClasses?.append(RemarkCellViewModel(model: segment))
        }
        
        if let date = pnrInfo.last_purchase_date {
            self.latestPurchaseDateCellViewModel = LatestPurchaseCellViewModel(date: date, is_ticketed: pnrInfo.pnr?.is_ticketed)
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 26
        case 4:
            if self.type != "RP"{
                return 50
            } else {
                return 107
            }
        case 5:
            return 62
        case 6:
            return self.passengers?.count > 0 ? 61 : 0
        case 7:
            return self.flights?.count > 0 ? 93 : 0
        case 8:
            return self.hotels?.count > 0 ? 114 : 0
        case 9:
            return self.cars?.count > 0 ? 193 : 0
        default:
            return 21
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.contentProvider?.results.value?.count > 0 ? 10 : 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1, 2, 3:
            return CGFloat.min
        case 4:
            if self.type != "RP"{
                return self.contactCellViewModel != nil ? tableView.sectionFooterHeight : CGFloat.min
            }
            return self.statusCellViewModel != nil ? tableView.sectionFooterHeight : CGFloat.min
        case 5:
            return self.pnrCellViewModel != nil ? tableView.sectionFooterHeight : CGFloat.min
        case 6:
            return self.passengers?.count > 0 ? tableView.sectionFooterHeight : CGFloat.min
        case 7:
            return self.flights?.count > 0 ? tableView.sectionFooterHeight : CGFloat.min
        case 8:
            return self.hotels?.count > 0 ? tableView.sectionFooterHeight : CGFloat.min
        case 9:
            return self.cars?.count > 0 ? tableView.sectionFooterHeight : CGFloat.min
        default:
            return tableView.sectionFooterHeight
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderView") as! HeaderView
        switch section {
        case 0, 1, 2,3:
            cell.textTitle = nil
        case 4:
            if self.type != "RP"{
                cell.textTitle = self.contactCellViewModel != nil ? " CONTACT" : nil
            }
            cell.textTitle = " STATUS"
        case 5:
            cell.textTitle = self.pnrCellViewModel != nil ? " PNR DATA" : nil
        case 6:
            cell.textTitle = self.passengers?.count > 0 ? " PASSENGERS" : nil
        case 7:
            cell.textTitle = self.flights?.count > 0 ? " FLIGHT" : nil
        case 8:
            cell.textTitle = self.hotels?.count > 0 ? " HOTEL" : nil
        case 9:
            cell.textTitle = self.cars?.count > 0 ? " CAR RENTAL" : nil
        default:
            cell.textTitle = nil
        }

        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("FooterView")
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0, 1, 2, 3:
            return nil
        case 4:
            if self.type != "RP"{
                return self.contactCellViewModel != nil ? " CONTACT" : nil
            }
            return " STATUS"
        case 5:
            return self.pnrCellViewModel != nil ? " PNR DATA" : nil
        case 6:
            return self.passengers?.count > 0 ? " PASSENGERS" : nil
        case 7:
            return self.flights?.count > 0 ? " FLIGHT" : nil
        case 8:
            return self.hotels?.count > 0 ? " HOTEL" : nil
        case 9:
            return self.cars?.count > 0 ? " CAR RENTAL" : nil
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return self.latestPurchaseDateCellViewModel != nil ? 1 : 0
        case 1:
            return self.segmentClasses?.count ?? 0
        case 2:
            return self.alerts?.count ?? 0
        case 3:
            return self.remarks?.count ?? 0
        case 4:
            if self.type != "RP"{
                return self.contactCellViewModel != nil ? 1 : 0
            }
            return 1
        case 5:
            return self.pnrCellViewModel != nil ? 1 : 0
        case 6:
            return self.passengers?.count ?? 0
        case 7:
            return self.flights?.count ?? 0
        case 8:
            return self.hotels?.count ?? 0
        case 9:
            return self.cars?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellForReturn: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRLatestPurchaseCell", forIndexPath: indexPath) as! PNRLatestPurchaseCell
            cell.viewModel = self.latestPurchaseDateCellViewModel
            cellForReturn = cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRRemarkCell", forIndexPath: indexPath) as! PNRRemarkCell
            cell.viewModel = self.segmentClasses![indexPath.row]
            cellForReturn = cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRAlertCell", forIndexPath: indexPath) as! PNRAlertCell
            cell.viewModel = self.alerts![indexPath.row]
            cellForReturn = cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRRemarkCell", forIndexPath: indexPath) as! PNRRemarkCell
            cell.viewModel = self.remarks![indexPath.row]
            cellForReturn = cell
        case 4:
            if self.type != "RP"{
                let cell = tableView.dequeueReusableCellWithIdentifier("PNRContactCell", forIndexPath: indexPath) as! PNRContactCell
                cell.viewModel = self.contactCellViewModel
                cellForReturn = cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("PNRStatusCell", forIndexPath: indexPath) as! PNRStatusCell
                cell.viewModel = self.statusCellViewModel
                cellForReturn = cell
            }
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRCell", forIndexPath: indexPath) as! PNRCell
            cell.viewModel = self.pnrCellViewModel
            cellForReturn = cell
        case 6:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRPassengerCell", forIndexPath: indexPath) as! PNRPassengerCell
            cell.viewModel = self.passengers![indexPath.row]
            cellForReturn = cell
        case 7:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRFlightCell", forIndexPath: indexPath) as! PNRFlightCell
            cell.viewModel = self.flights![indexPath.row]
            cellForReturn = cell
        case 8:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRHotelCell", forIndexPath: indexPath) as! PNRHotelCell
            cell.viewModel = self.hotels![indexPath.row]
            cellForReturn = cell
        case 9:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRCarCell", forIndexPath: indexPath) as! PNRCarCell
            cell.viewModel = self.cars![indexPath.row]
            cellForReturn = cell
        default:
            cellForReturn = UITableViewCell()
        }
        
        return cellForReturn
    }
}