//
//  HeaderTableViewCell.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 04/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var placesTitle: UILabel!
    @IBOutlet weak var forecastTitle: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placesTitle.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
