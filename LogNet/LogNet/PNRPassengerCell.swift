//
//  PNRPassengerCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRPassengerCell: UITableViewCell {

    @IBOutlet weak var passengerName: UILabel!
    
    var viewModel:PassengerCellViewModel! {
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
        self.passengerName.text = ""
        if let name = self.viewModel.first_name {
           self.passengerName.text = name
        }
        
        if let lastName = self.viewModel.last_name {
            self.passengerName.text = "\(self.passengerName.text!) \(lastName)"
        }
    }

}
