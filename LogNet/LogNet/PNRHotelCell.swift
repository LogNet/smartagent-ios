//
//  PNRHotelCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRHotelCell: UITableViewCell {

    @IBOutlet weak var hotelTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    var viewModel:HotelCellViewModel! {
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
        self.hotelTitleLabel.text = ""
        
        if let text = self.viewModel.hotel_name {
            self.hotelTitleLabel.text = text
        }
        
        if let text = self.viewModel.city {
            self.hotelTitleLabel.text = "\(self.hotelTitleLabel.text!), \(text)"
        }
        
        if let text = self.viewModel.country {
            self.hotelTitleLabel.text = "\(self.hotelTitleLabel.text!), \(text)"
        }
        
        self.statusLabel.text = self.viewModel.status
        self.periodLabel.text = ""
        
        if let text = self.viewModel.start {
            self.periodLabel.text = text
        }
        
        if let text = self.viewModel.end {
            self.periodLabel.text = "\(self.periodLabel.text!) - \(text)"
        }
        
        self.costLabel.text = self.viewModel.cost
    }
    
}
