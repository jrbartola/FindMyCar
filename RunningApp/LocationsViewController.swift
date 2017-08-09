//
//  LocationsViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 8/8/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTableView.delegate = self
        locationsTableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("LocationsTableViewCell", owner: self, options: nil)?.first as! LocationsTableViewCell
        
        cell.addressLabel.text = "\(Locations.locations[indexPath.row])"
        
        return cell
    }

}
