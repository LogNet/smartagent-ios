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

    
    override func subscribeToProvider (){
        self.contentProvider.results.asObservable().subscribeNext { object in
            if let pnrInfo = object?.first as? PNRInfo {
                self.parsePNRInfo(pnrInfo)
                self.tableView.reloadData()
            }
        }.addDisposableTo(self.disposeBag)
    }
    
    // MARK: - Private
    
    private func parsePNRInfo(pnrInfo:PNRInfo) {
        self.statusCellViewModel = StatusCellViewModel(title: pnrInfo.title)
        self.pnrCellViewModel = PNRCellViewModel(model: pnrInfo.pnr)
        
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
    
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 87
        case 1:
            return 62
        case 2:
            return 61
        case 3:
            return 93
        case 4:
            return 114
        case 5:
            return 193
        default:
            return 44
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.contentProvider?.results.value?.count > 0 ? 6 : 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return " STATUS"
        case 1:
            return " PNR DATA"
        case 2:
            return " PASSENGERS"
        case 3:
            return " FLIGHT"
        case 4:
            return " HOTEL"
        case 5:
            return " CAR RENTAL"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.passengers?.count ?? 0
        case 3:
            return self.flights?.count ?? 0
        case 4:
            return self.hotels?.count ?? 0
        case 5:
            return self.cars?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellForReturn: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRStatusCell", forIndexPath: indexPath) as! PNRStatusCell
            cell.viewModel = self.statusCellViewModel
            cellForReturn = cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRCell", forIndexPath: indexPath) as! PNRCell
            cell.viewModel = self.pnrCellViewModel
            cellForReturn = cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRPassengerCell", forIndexPath: indexPath) as! PNRPassengerCell
            cell.viewModel = self.passengers![indexPath.row]
            cellForReturn = cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRFlightCell", forIndexPath: indexPath) as! PNRFlightCell
            cell.viewModel = self.flights![indexPath.row]
            cellForReturn = cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRHotelCell", forIndexPath: indexPath) as! PNRHotelCell
            cell.viewModel = self.hotels![indexPath.row]
            cellForReturn = cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier("PNRCarCell", forIndexPath: indexPath) as! PNRCarCell
            cell.viewModel = self.cars![indexPath.row]
            cellForReturn = cell
        default:
            cellForReturn = UITableViewCell()
        }
        
        return cellForReturn
    }
}