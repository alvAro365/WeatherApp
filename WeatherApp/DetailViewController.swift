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
    var favorites = [City]()
    var test: String = "Test funkar"
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var saveFavorite: UIBarButtonItem!
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        let mainViewController = segue.destination as? WeatherAppViewController
//        mainViewController?.city = city!
//    }
    
    // MARK: Actions
    @IBAction func saveAsFavorite(_ sender: UIBarButtonItem) {
        sender.image = #imageLiteral(resourceName: "star-filled")
        favorites.append(city!)
        
        if Storage.save(favorites) {
            print("Saving succeeded")
            print(favorites.count)
        } else {
            print("Saving failed")
        }
    }
}
