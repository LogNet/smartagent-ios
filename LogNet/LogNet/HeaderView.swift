//
//  HeaderView.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/6/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var line: UIView!

    var textTitle:String? {
        set {
            self.setTitleText(newValue)
        }
        get {
            return self.title.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitleText(string:String?) {
        self.title.text = string
        if self.title.text == nil {
            self.line.hidden = true
        } else {
            self.line.hidden = false
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
