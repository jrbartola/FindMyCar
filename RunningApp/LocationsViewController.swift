//
//  LocationsViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 8/8/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationsTableView: UITableView!
    
    let locationsCellIdentifier = "LocationsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        
        locationsTableView.register(LocationsTableViewCell.self, forCellReuseIdentifier: locationsCellIdentifier)
        
    }
    
    func removeLeftBarButton() {
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    func removeRightBarButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = locationsTableView.dequeueReusableCell(withIdentifier: locationsCellIdentifier) as! LocationsTableViewCell
        
        cell.tableView = self.locationsTableView
        
        cell.addressLabel.text = "\(Locations.locations[indexPath.row].address)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! LocationsTableViewCell
        let loc = Locations.locations[indexPath.row]
        let destination = loc.address
        
        // Find route from current location to destination using the mapViewController
        let mapVC = self.tabBarController?.viewControllers![1] as! MapViewController
    
        mapVC.getRouteTo(location: loc)
        mapVC.addLeftBarButton()
        mapVC.addRightBarButton()
        self.tabBarController?.selectedIndex = 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            Locations.locations.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
    

}
