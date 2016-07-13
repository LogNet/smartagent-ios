//
//  NotificationCell.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/23/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class RecentNotificationCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var pnrSummary: UILabel!
    
    func setViewModel(viewModel:RecentNotificationCellViewModel?) {
        self.title.text = viewModel?.title
        self.contactName.text = viewModel?.contactName
        self.pnrSummary.text = viewModel?.pnrSummary
        self.date.text = viewModel?.date
    }
}
