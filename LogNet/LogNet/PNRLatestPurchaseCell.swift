//
//  LatestPurchaseCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRLatestPurchaseCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel:LatestPurchaseCellViewModel! {
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
    
    private func prepareView(){
        if self.viewModel.isTicketed == true {
            self.dateLabel.textColor = UIColor.redColor()
            self.dateLabel.text = "This PNR is ticketed!"
        } else {
            self.dateLabel.text = self.viewModel.latestPutchaseDate
        }
    }
    
}
