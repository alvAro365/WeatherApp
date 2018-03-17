//
//  SearchTableViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 11/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    var searchController: UISearchController!
    var cities = [City]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        searchController.searchBar.delegate = self
        tabBarController?.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        self.searchController.searchBar.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("******viewDidAppear")
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
        print("***View did disappear")
        cities.removeAll()
        self.tableView.reloadData()
        
    }

    // MARK: TabBarController delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        searchController.isActive = false
        self.searchController.searchBar.resignFirstResponder()
        print("TabBar didSelect")
        cities.removeAll()
        self.tableView.reloadData()

    }
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        return tabBarController.selectedIndex == 0
//    }
    // MARK: SearchBar delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cities.removeAll()
        self.tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil {
            cities.removeAll()
            self.searchController.searchBar.resignFirstResponder()
            self.tableView.reloadData()
        } else if searchBar.text == "" {
            cities.removeAll()
//            self.searchController.searchBar.resignFirstResponder()
            self.tableView.reloadData()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        searchController.isActive = false
        cities.removeAll()
        searchBar.resignFirstResponder()
        tableView.reloadData()
        
    }

    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Sets this view controller as presenting view controller for the search interface
//        definesPresentationContext = false
    }
    // MARK: SearchController delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            City.cities(matching: searchText) { cities in self.cities = cities
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataTableViewCell
        
        cell.place?.text = cities[indexPath.row].name
        let temp = Int(cities[indexPath.row].temperature)
        cell.temp.text = "\(temp)℃"
        cell.forecast.text = cities[indexPath.row].icon
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailView" {
            let detailViewController = segue.destination as? DetailViewController
            let selectedCityCell = sender as? DataTableViewCell
            let indexPath = tableView.indexPath(for: selectedCityCell!)
            let selectedCity = cities[(indexPath?.row)!]
//            cities.removeAll()
            detailViewController?.city = selectedCity
//            self.searchController.searchBar.resignFirstResponder()
//            searchController.isActive = false
//            self.tableView.reloadData()
        }
    }
    
    // MARK: NavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("hei")
    }
    
    // TODO: clear search on tab click
}


