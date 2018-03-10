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
        
        let keyValue = Array(favorites)[indexPath.row].key
        let values = favorites[keyValue]
        cell.place?.text = keyValue
        cell.forecast.text = values?["forecast"]
        cell.temp.text = values?["temp"]

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
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
}


