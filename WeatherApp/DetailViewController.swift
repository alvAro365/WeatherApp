//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 15/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: Properties
    var city: City? = nil
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var iconLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let city = city {
            navigationItem.title = city.name
            cityLable.text = city.name
            let temp = Int(city.temperature)
            temperatureLabel.text = "\(temp)℃"
            windLabel.text = "\(city.wind) m/s"
            iconLabel.text = city.icon
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
