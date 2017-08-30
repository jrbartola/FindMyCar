//
//  LocationsViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 8/8/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*** Load Locations from CoreData ***/
        self.loadLocationData()
        
        let backgroundView = UIImageView(image: #imageLiteral(resourceName: "roadbackground"))
        backgroundView.contentMode = .scaleAspectFill
        
        locationsTableView.backgroundView = backgroundView
        
        // Remove extra separators after existing cells
        locationsTableView.tableFooterView = UIView()
        
        // Remove table view separators all together
        locationsTableView.separatorStyle = .none
        
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        
        locationsTableView.register(LocationsTableViewCell.self, forCellReuseIdentifier: locationsCellIdentifier)
        
    }
    
    private func loadLocationData() {
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            LocationStore.locations = searchResults
            
        } catch {
            print("ERROR FETCHING FROM COREDATA: \(error)")
            LocationStore.locations = []
        }
        
    }
    
    func removeLeftBarButton() {
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    func removeRightBarButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationStore.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = locationsTableView.dequeueReusableCell(withIdentifier: locationsCellIdentifier) as! LocationsTableViewCell
        
        cell.backgroundColor = .clear
        
        // Add a rounded view to the tableview cell
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 60))
        
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        
        cell.tableView = self.locationsTableView
        cell.addressLabel.text = "\(LocationStore.locations[indexPath.row].address)"
        cell.dateLabel.text = "\(Util.parseDate(date: LocationStore.locations[indexPath.row].date as! Date))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! LocationsTableViewCell
        let loc = LocationStore.locations[indexPath.row]
        let destination = loc.address
        
        // Find route from current location to destination using the mapViewController
        let mapVC = self.tabBarController?.viewControllers![1] as! MapViewController
 
        let container = UIView()
        let loadingView = UIView()
        let activityIndicator = UIActivityIndicatorView()
        
        mapVC.addLeftBarButton()
        mapVC.addRightBarButton()
        
        Util.showActivityIndicator(uiView: mapVC.view, container: container, loadingView: loadingView, activityIndicator: activityIndicator)
        
        mapVC.getRouteTo(location: loc, callback: {
            Util.stopActivityIndicator(uiView: mapVC.view, container: container, loadingView: loadingView, activityIndicator: activityIndicator)
        })

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
            LocationStore.locations.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
    

}
