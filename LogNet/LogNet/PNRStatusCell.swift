//
//  PNRStatusCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRStatusCell: UITableViewCell {
    
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    var viewModel:StatusCellViewModel! {
        didSet{
            self.prepareView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func prepareView() {
        self.notificationTitle.text = self.viewModel.title
        self.switchControl.on = self.viewModel.keepRepricing
        self.switchControl.enabled = true
    }
}
