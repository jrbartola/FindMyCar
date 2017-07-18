//
//  MainViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 7/14/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit
import MapKit


class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        self.mapView.mapType = MKMapType.hybrid
        centerMapOnLocation()
        
        
    }
    
    func centerMapOnLocation() {
        if let coordinate = self.locationManager.location?.coordinate {
            self.mapView.setCenter(coordinate, animated: true)
        }
    }

}

