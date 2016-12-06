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
    let isTicketed:Bool?
    init(date:String, is_ticketed:String?) {
        self.latestPutchaseDate = "Last purchase - \(date)"
        self.isTicketed = is_ticketed?.toBool()
    }
}