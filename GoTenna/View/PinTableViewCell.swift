//
//  PinTableViewCell.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import UIKit

class PinTableViewCell: UITableViewCell {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    func setUp(pin: Pin, location: Double) {
        nameLabel.text = pin.name
        descriptionLabel.text = pin.description
        distanceLabel.text = String(format: "%.1f", location) + " mi"
        distanceLabel.textColor = UIColor.gray
    }
}
