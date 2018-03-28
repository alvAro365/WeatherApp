//
//  DataTableViewCell.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 09/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var forecast: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var noResult: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let colorView = UIView()
        colorView.backgroundColor = UIColor.black
        self.selectedBackgroundView = colorView
    }
}
