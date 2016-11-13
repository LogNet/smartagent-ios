//
//  LatestPurchaseCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class LatestPurchaseCellViewModel {
    
    let latestPutchaseDate:String
    
    init(date:String) {
        self.latestPutchaseDate = "Last ticketing date - \(date)"
    }
}