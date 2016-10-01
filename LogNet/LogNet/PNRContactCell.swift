//
//  PNRContactCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRContactCell: UITableViewCell {
    @IBOutlet weak var contactName: UILabel!
    
    var viewModel:ContactCellViewModel! {
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
        self.contactName.text = self.viewModel.name
    }

}
