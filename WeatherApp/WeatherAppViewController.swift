//
//  WeatherAppViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 04/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class WeatherAppViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var city: City?
    var favoriteCities: [City]? = []
    var citiesToCompare: [City] = []
//    var filteredData = [String: [String: String]]()
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var searchController: UISearchController!
    var indexPathsForSelectedRows: [NSIndexPath]?
    var compareButton: UIBarButtonItem?
    var selectedCities: [Int] = []
    
    
    // MARK: Private cunctions
    func updateCompareButtonStatus() {
        if tableView.isEditing {
            if let selection = tableView.indexPathsForSelectedRows {
                if selection.count >= 2 {
                    actionButton.isEnabled = true
                } else if selection.count < 2  {
                    actionButton.isEnabled = false
                }
            } else {
                actionButton.isEnabled = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateCompareButtonStatus()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
        cancelButton.isEnabled = false
        if Storage.fileExists() {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Storage.fileExists() {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
        }
        if (favoriteCities?.count)! < 2 {
            actionButton.isEnabled = false
        } else {
            actionButton.isEnabled = true
        }
        
        if Storage.fileExists() {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCompareButtonStatus()
    }
    @IBAction func onCancelClick(_ sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        cancelButton.isEnabled = false
        actionButton.isEnabled = true
        updateCompareButtonStatus()
        
    }
    @IBAction func toggleAction(_ sender: Any) {
        cancelButton.isEnabled = true
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for selection in indexPaths {
                citiesToCompare.append(favoriteCities![selection.row])
            }
            cancelButton.isEnabled = false
        }
        tableView.setEditing(!tableView.isEditing, animated: true)
        if !tableView.isEditing {
            self.performSegue(withIdentifier: "barChart", sender: self)
        }
        citiesToCompare.removeAll()
        updateCompareButtonStatus()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataTableViewCell
        if let favorites = favoriteCities {
            let city = favorites[indexPath.row]
            cell.forecast.text = city.icon
            cell.place.text = city.name
            let temp = city.temperature
            cell.temp.text = "\(temp)℃"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favoriteCities?.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateCompareButtonStatus()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateCompareButtonStatus()
        }
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
            
        } else if segue.identifier == "barChart" {
            
            let chartBarViewController = segue.destination as? ChartBartViewController
            chartBarViewController?.citiesToCompare = citiesToCompare
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
        
    }
}


