//
//  MainViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 7/14/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit
import MapKit


class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 1000
            let coordinate = locationManager.location?.coordinate
            
            
            mapView.showsUserLocation = true
            //mapView.mapType = MKMapType.hybrid
            
            centerMapOnLocation(coordinate: coordinate)
        }
        
        searchBar.delegate = self
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        centerMapOnLocation(coordinate: location.coordinate)
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D?) {
        if let coord = coordinate {
            self.mapView.setCenter(coord, animated: true)
            let span = MKCoordinateSpanMake(0.075, 0.075)
            let region = MKCoordinateRegion(center: coord, span: span)
            
            self.mapView.setRegion(region, animated: true)

        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        print(searchBar.text!)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBar.text!) { (placemarks: [CLPlacemark]?, error: Error?) in
            
            if error == nil {
                
                let placemark = placemarks?.first
                
                if let coordinate = placemark?.location?.coordinate {
                    let destPlacemark = MKPlacemark(coordinate: coordinate)
                    self.getRouteTo(destPlacemark: destPlacemark)
                }
                
                
                
                let coordinate = (placemark?.location?.coordinate)!
                
//                let anno = MKPointAnnotation()
//                anno.coordinate = (placemark?.location?.coordinate)!
//                anno.title = searchBar.text!
                
//                let span = MKCoordinateSpanMake(0.075, 0.075)
//                let region = MKCoordinateRegion(center: anno.coordinate, span: span)
//                
//                self.mapView.setRegion(region, animated: true)
//                self.mapView.addAnnotation(anno)
//                self.mapView.selectAnnotation(anno, animated: true)
                
            } else {
                print(error?.localizedDescription ?? "ERROR: ABORTING SEARCH")
            }
        }
    }
    
    func getRouteTo(destPlacemark: MKPlacemark) {
        let currentPlacemark = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        
        let currentItem = MKMapItem(placemark: currentPlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = currentItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate(completionHandler: { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            // Grab first route from the array
            let route = response.routes[0]
            //print(route.steps)
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let boundingRectangle = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(boundingRectangle), animated: true)
        })
        
    }

}

