//
//  SearchHistoryCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import UIKit
class SearchHistoryCellViewModel {
    let rowHeight = CGFloat(44.0)
    let model:SearchHistoryItem
    var suggestTitle: String?
    
    init(model:SearchHistoryItem){
        self.model = model
        self.suggestTitle = self.model.query
    }
    
}