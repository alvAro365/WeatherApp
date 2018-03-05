//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 04/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    let data = ["Tallinn", "Gothenburg", "Oslo"]
    var filteredData: [String]!
    var searchController: UISearchController!
    
    // MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        filteredData = data
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        tableView.tableHeaderView = searchController.searchBar
//        navigationItem.titleView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
//    func createSearchBar() {
//
//        let searchBar = UISearchBar()
//        searchBar.showsCancelButton = false
//        searchBar.placeholder = "Search"
//        searchBar.delegate = self
//        self.navigationItem.titleView = searchBar
//
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Cells
  func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "TitleCell")
        return headerView
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                return (dataString.range(of: searchText, options: .caseInsensitive) != nil)
            })
            tableView.reloadData()
        }
    }

}


