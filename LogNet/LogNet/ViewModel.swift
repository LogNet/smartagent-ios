//
//  ViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/22/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class ViewModel: NSObject {

    internal var router:Router

    init(router:Router) {
        self.router = router
    }

}
