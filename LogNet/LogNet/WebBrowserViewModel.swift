//
//  BrowserViewModel.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class WebBrowserViewModel:ViewModel {
    dynamic var urlString:String?
    private var browserModel:WebBrowserModel?
    
    init(browserModel:WebBrowserModel, router:Router) {
        self.browserModel = browserModel;
        self.urlString = "http://www.lognet-travel.com/"
        super.init(router: router)
    }
}