//
//  PinTableViewCell.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import UIKit

class PinTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    func setUp(pin: Pin) {
        nameLabel.text = pin.name
        descriptionLabel.text = pin.description
    }
}
