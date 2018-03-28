//
//  SearchTableViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 11/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    // MARK: Properties
    var searchController: UISearchController!
    var cities = [City]()
    @IBOutlet weak var noResult: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.separatorStyle = .none
        searchController.searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    // MARK: SearchBar delegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.isActive = false
        cities.removeAll()
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    // MARK: Helper methods
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barStyle = .black
        searchController.searchBar.placeholder = "Search by city"
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = false
    }
    // MARK: SearchController delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            
//            print("No result")
            noResult.text = "No result"
            City.cities(matching: searchText, updating: nil) { cities in self.cities = cities
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            noResult.text = ""
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
        
        let city = cities[indexPath.row]
        cell.place?.text = "\(city.name)"
        cell.country.text = "\(city.country)"
        cell.temp.text = "\(city.temperature)℃"
        cell.forecast.text = city.icon
        noResult.text = ""
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailView" {
            let detailViewController = segue.destination as? DetailViewController
            let selectedCityCell = sender as? DataTableViewCell
            let indexPath = tableView.indexPath(for: selectedCityCell!)
            let selectedCity = cities[(indexPath?.row)!]
            detailViewController?.city = selectedCity
        }
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
}


