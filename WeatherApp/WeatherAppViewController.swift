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
    var citiesToUpdate: [String] = []
    @IBOutlet weak var actionButton: UIBarButtonItem!
    var indexPathsForSelectedRows: [NSIndexPath]?

    // MARK: Helper functions
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
    
    func updateActionButtonStatus() {
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
    @IBAction func compare(_ sender: UIBarButtonItem) {
        toggleAction()
    }
    
    func deactivateEditMode() {
        tableView.setEditing(false, animated: true)
    }
    
    func showCancelButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector (cancelClick))
    }
    
    func showActionButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector (toggleAction))
    }
    
    @objc func cancelClick() {
        deactivateEditMode()
          actionButton.isEnabled = true
        self.navigationController?.toolbar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        showActionButton()
    }
    func hideToolbar() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.toolbar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorStyle = .none
        showActionButton()
        reloadData()
        if favoriteCities!.count > 0 {
            updateData()
        }
        self.navigationController?.toolbar.isHidden = true
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideToolbar()
        reloadData()
        if (favoriteCities?.count)! < 2 {
            actionButton.isEnabled = false
        } else {
            actionButton.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateActionButtonStatus()
        hideToolbar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deactivateEditMode()
        showActionButton()
    }
    
    @objc func toggleAction() {
        showCancelButton()
        self.navigationController?.toolbar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for selection in indexPaths {
                citiesToCompare.append(favoriteCities![selection.row])
            }
            showActionButton()
        }
        tableView.setEditing(!tableView.isEditing, animated: true)
        if !tableView.isEditing {
            self.performSegue(withIdentifier: "barChart", sender: self)
        }
        citiesToCompare.removeAll()
        updateActionButtonStatus()
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
            updateActionButtonStatus()
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.black
        if tableView.isEditing {
            updateActionButtonStatus()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showFavoriteDetails" {
            let detailViewController = segue.destination as? DetailViewController
            let selectedCityCell = sender as? DataTableViewCell
            let indexPath = tableView.indexPath(for: selectedCityCell!)
            let selectedCity = favoriteCities![(indexPath?.row)!]
            detailViewController?.city = selectedCity
        } else if segue.identifier == "barChart" {
            let chartBarViewController = segue.destination as? ChartBartViewController
            chartBarViewController?.citiesToCompare = citiesToCompare
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
        
    }
}


