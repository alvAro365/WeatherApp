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
//    var search: String = "Tall"
    var places = ["Tallinn"]
    var cities = [City]()


    // MARK: WebAPI
    func createJsonTask(search:String) {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(search)&type=like&units=metric&appid=d8b585f530bf87bf33de4f4939f30f63")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if ((jsonResult as? [String : Any]) != nil) {
                            if let dictionary = jsonResult["main"] as? [String : Any] {
                                self.places.append(jsonResult["name"]! as! String)
                                print("Temperature in \(jsonResult["name"]!!) is \(dictionary["temp"]!)")
                            }
                        }
                        print(jsonResult)
                    } catch {
                        print("Json Processing Failed")
                    }
                }
            }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        searchController.searchBar.delegate = self
        
        //createJsonTask(search: "oslo")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    // MARK: SearchBar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
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
    // MARK: SearchController functions

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            //createJsonTask(search: searchText)
            City.cities(matching: searchText) { cities in self.cities = cities
                self.tableView.reloadData()
            }
        
        }
        self.tableView.reloadData()
        
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
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataTableViewCell

        cell.place?.text = places[indexPath.row]

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
