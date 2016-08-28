//
//  PNRCreatorCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRCell: UITableViewCell {
    @IBOutlet weak var pnrIDLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    
    var viewModel:PNRCellViewModel! {
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
        self.pnrIDLabel.text = self.viewModel.id
        self.creatorLabel.text = self.viewModel.creator
    }
}
