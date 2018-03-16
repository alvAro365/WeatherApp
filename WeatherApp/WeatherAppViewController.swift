//
//  WeatherAppViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 04/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class WeatherAppViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var city: City?
    var test: String = ""
    var favoriteCities: [City]?
    let data = ["New York": ["forecast": "☁️", "temp": "20℃"],
                 "Lisbon": ["forecast": "☀️", "temp": "30℃"],
        "Paris": ["forecast": "🌧", "temp": "5℃"]]
    
    
    let favorites = ["Tallinn": ["forecast": "☁️", "temp": "20℃"],
                "Oslo": ["forecast": "☀️", "temp": "30℃"],
                "Algarve": ["forecast": "🌧", "temp": "5℃"]]
    
    var filteredData = [String: [String: String]]()
    var searchController: UISearchController!
    
    // MARK: Private cunctions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        filteredData = data
        setupSearchController()
        if FileManager.default.fileExists(atPath: Storage.ArchiveURL.path) {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
            print("The count is: \(String(describing: favoriteCities?.count))")
        }
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        navigationItem.searchController = searchController
//        tableView.tableHeaderView = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataTableViewCell
        if let favorites = favoriteCities {
            print("***** \(favorites.count)")
            let city = favoriteCities![indexPath.row]
            cell.forecast.text = city.icon
            cell.place.text = city.name
            let temp = Int(city.temperature)
            cell.temp.text = "\(temp)℃"
        }
//        let keyValue = Array(favorites)[indexPath.row].key
//        let values = favorites[keyValue]
//        cell.place?.text = keyValue
//        cell.forecast.text = values?["forecast"]
//        cell.temp.text = values?["temp"]

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favoriteCities?.count)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: Custom views
   func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "TitleCell")
        return headerView
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? filteredData : data.filter{(key,value) -> Bool in
                return (key.range(of: searchText, options: .caseInsensitive) != nil)
            }
            tableView.reloadData()
        }
    }
    // MARK: Navigation
//    @IBAction func unwindToFavorites(sender: UIStoryboardSegue) {
//
//        if let sourceViewController = sender.source as? DetailViewController {
//            city = sourceViewController.city
////            print(city!)
////            favoriteCities.append(city!)
//            let newIndexPath = IndexPath(row: favoriteCities.count, section: 0)
//            favoriteCities.append(city!)
//            print("Favorites count: \(favoriteCities.count)")
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
////            self.tableView.reloadData()
//        }
//        print(test)
//    }
}


