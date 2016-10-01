//
//  StatusCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class StatusCellViewModel {
    let title: String?
    var keepRepricing:Bool = false
    
    init (title:String?) {
        self.title = title
    }

}
