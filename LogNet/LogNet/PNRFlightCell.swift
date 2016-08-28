//
//  PNRFlightCell.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class PNRFlightCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var flightClassLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var viewModel:FlightCellViewModel! {
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
        self.fromLabel.text = self.viewModel.from
        self.toLabel.text = self.viewModel.to
        self.departureLabel.text = self.viewModel.departure
        self.arrivalLabel.text = self.viewModel.arrival
        self.flightNumberLabel.text = self.viewModel.flight_number
        self.flightClassLabel.text = self.viewModel.flight_class
        self.statusLabel.text = self.viewModel.status
    }
}
