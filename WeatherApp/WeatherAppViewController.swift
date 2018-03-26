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
    var citiesToUpdate: [String] = []
    
    
    // MARK: Private functions
    func updateData() {
        if Storage.fileExists() {
            favoriteCities = Storage.load([City].self)
            for city in favoriteCities! {
                let cityId = String(city.cityId)
                citiesToUpdate.append(cityId)
            }
            City.cities(matching: nil, updating: citiesToUpdate) { cities in self.favoriteCities = cities
                DispatchQueue.main.async {
                    if Storage.save(self.favoriteCities) {
                        print("Update saved")
                    } else {
                        print("Update failed")
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    func reloadData() {
        if Storage.fileExists() {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
        }
    }
    func updateCompareButtonStatus() {
        if tableView.isEditing {
            if let selection = tableView.indexPathsForSelectedRows {
                if selection.count < 2 || selection.count > 5 {
                    actionButton.isEnabled = false
                } else {
                    actionButton.isEnabled = true
                }
            } else {
                actionButton.isEnabled = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        cancelButton.isEnabled = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorStyle = .none
        reloadData()
        if favoriteCities!.count > 0 {
            updateData()

        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        if (favoriteCities?.count)! < 2 {
            actionButton.isEnabled = false
        } else {
            actionButton.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCompareButtonStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView.setEditing(false, animated: true)
        cancelButton.isEnabled = false
    }
    @IBAction func onCancelClick(_ sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        actionButton.isEnabled = true
        cancelButton.isEnabled = false

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
        let selectedCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.black
        if tableView.isEditing {
            updateCompareButtonStatus()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.black
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
            detailViewController?.favorites = favoriteCities!
        } else if segue.identifier == "barChart" {
            let chartBarViewController = segue.destination as? ChartBartViewController
            chartBarViewController?.citiesToCompare = citiesToCompare
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
        
    }
}


