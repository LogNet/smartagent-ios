//
//  NotificationCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import QuartzCore

class NotificationCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var pnrSummary: UILabel!
    @IBOutlet weak var readIndicator:UIView!
    @IBOutlet weak var noticeIndicator:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setViewModel(viewModel:RecentNotificationCellViewModel) {
        let title = NSMutableAttributedString(string: viewModel.title!)
        if let message = viewModel.titleMessage {
            let attribute = [ NSFontAttributeName: UIFont(name: "SanFranciscoText-Regular", size: 12.0)! ]
            let attrString = NSAttributedString(string:" - " + message, attributes: attribute)
            title.appendAttributedString(attrString)
        }
        
        self.title.attributedText = title
        self.pnrSummary.text = viewModel.pnrSummary
        self.date.text = viewModel.date
        self.readIndicator.hidden = viewModel.isRead
        self.contactName.text = viewModel.contactName
        self.noticeIndicator.hidden = !viewModel.alert_indicator
    }
    
}
