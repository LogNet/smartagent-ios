//
//  PNRRemerkCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRRemarkCell: UITableViewCell {
    
    @IBOutlet weak var remarkTextLabel: UILabel!

    var viewModel:RemarkCellViewModel! {
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
        self.remarkTextLabel.text = self.viewModel.text
    }

}
