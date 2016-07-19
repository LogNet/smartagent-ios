//
//  NotificationCell.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class RecentNotificationCell: NotificationCell {
    
    @IBOutlet weak var typeIconView: UIImageView!
    
    override func setViewModel(viewModel: RecentNotificationCellViewModel) {
        super.setViewModel(viewModel)
        
    }
}
