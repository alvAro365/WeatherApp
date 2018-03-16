//
//  WeatherAppViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 04/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class WeatherAppViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var city: City?
    var favoriteCities: [City]? = []
//    var filteredData = [String: [String: String]]()
    var searchController: UISearchController!
    
    // MARK: Private cunctions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        setupSearchController()
        if FileManager.default.fileExists(atPath: Storage.ArchiveURL.path) {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FileManager.default.fileExists(atPath: Storage.ArchiveURL.path) {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
        }
    }
    
//    func setupSearchController() {
//        searchController = UISearchController(searchResultsController: nil)
////        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.barTintColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
//        navigationItem.searchController = searchController
//        // Sets this view controller as presenting view controller for the search interface
//        definesPresentationContext = true
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataTableViewCell
        if let favorites = favoriteCities {
            let city = favorites[indexPath.row]
            cell.forecast.text = city.icon
            cell.place.text = city.name
            // TODO: fix casting
            let temp = Int(city.temperature)
            cell.temp.text = "\(temp)℃"
        }
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
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            filteredData = searchText.isEmpty ? filteredData : data.filter{(key,value) -> Bool in
//                return (key.range(of: searchText, options: .caseInsensitive) != nil)
//            }
//            tableView.reloadData()
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showFavoriteDetails" {
            let detailViewController = segue.destination as? DetailViewController
            let selectedCityCell = sender as? DataTableViewCell
            let indexPath = tableView.indexPath(for: selectedCityCell!)
            let selectedCity = favoriteCities![(indexPath?.row)!]
            detailViewController?.city = selectedCity
            detailViewController?.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    // TODO: clear search on tab click
}


