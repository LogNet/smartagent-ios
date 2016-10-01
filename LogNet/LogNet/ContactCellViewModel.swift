//
//  ContactCellViewModel.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class ContactCellViewModel{
    var name:String?
    var phone:String?
    var email:String?
    let model:Contact

    init (model:Contact) {
        self.model = model
        self.prepareViewModel()
    }
    
    func prepareViewModel(){
        self.name = self.model.name
        self.phone = self.model.phone
        self.email = self.model.email
    }
}