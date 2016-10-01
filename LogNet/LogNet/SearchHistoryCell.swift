//
//  SearchHistoryCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class SearchHistoryCell: UITableViewCell {

    @IBOutlet weak var suggestTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setViewModel(viewModel:SearchHistoryCellViewModel) {
        self.suggestTitle.text = viewModel.suggestTitle
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
