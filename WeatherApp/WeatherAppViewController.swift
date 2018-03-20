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
    var citiesToCompare: [City]? = []
//    var filteredData = [String: [String: String]]()
    @IBOutlet weak var actionButton: UIBarButtonItem!
    var searchController: UISearchController!
    var indexPathsForSelectedRows: [NSIndexPath]?
    var compareButton: UIBarButtonItem?
    
    // MARK: Private cunctions
    
    func updateCompareButtonStatus() {
        if tableView.isEditing {
            if let selection = tableView.indexPathsForSelectedRows {
                if selection.count >= 2 {
                    
//                    actionButton.title = "Show(\(selection.count))"
                    actionButton.isEnabled = true
                } else if selection.count == 1  {
                    actionButton.isEnabled = false
//                    actionButton.title = "Show(\(selection.count))"
                }
            } else {
//                actionButton.title = "Show(0)"
                actionButton.isEnabled = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
//        setupSearchController()
//        compareButton  = UIBarButtonItem(title: "Compare", style: .plain, target: self, action: #selector(toggleEditing))
//        navigationItem.rightBarButtonItem = compareButton
        tableView.allowsMultipleSelectionDuringEditing = true
        if Storage.fileExists() {
            favoriteCities = Storage.load([City].self)
            tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    @IBAction func toggleAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
//        let destinationViewController = ChartBartViewController()
//        self.navigationController?.pushViewController(destinationViewController, animated: true)
//        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Show" : "Compare"
        if (citiesToCompare?.count)! >= 2 {
            print("Cities Count is 2 or bigger")
            self.performSegue(withIdentifier: "barChart", sender: self)
        }
        citiesToCompare?.removeAll()
        print("Toggle pressed")
        
        updateCompareButtonStatus()
        
    }
    
//    @objc private func toggleEditing() {
//        self.performSegue(withIdentifier: "compare", sender: self)
//        tableView.setEditing(tableView.isEditing, animated: true)
//        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Show" : "Compare"
//        print("Toggle pressed")
//
//        updateCompareButtonStatus()
//    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let city = favoriteCities![indexPath.row]
            citiesToCompare?.append(city)
            print("DidSelect city - \(String(describing: citiesToCompare?.count))")
            updateCompareButtonStatus()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //  TODO: fix bug when not deselecting last item first.
//        let city = favoriteCities![indexPath.row]
        if tableView.isEditing {
            citiesToCompare?.remove(at: indexPath.row)
        
            print("DidDeSelect city - \(String(describing: citiesToCompare?.count))")
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
            chartBarViewController?.citiesToCompare = citiesToCompare!
            print("Preparing for ChartBarViewController")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
        
    }
    
    // MARK: UITableViewDataSource methods
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
//    
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
}


