//
//  PNRCarCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRCarCell: UITableViewCell {

    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var viewModel:CarCellViewModel! {
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
        self.pickupLabel.text = ""
        if let text = self.viewModel.pickup_city {
            self.pickupLabel.text = text
        }
        if let text = self.viewModel.pickup_date {
            self.pickupLabel.text = "\(self.pickupLabel.text!)| \(text)"
        }
        self.returnLabel.text = self.viewModel.return_date
        self.carTypeLabel.text = self.viewModel.car_type
        self.vendorLabel.text = self.viewModel.vendor
        self.amountLabel.text = self.viewModel.amount
    }
}
