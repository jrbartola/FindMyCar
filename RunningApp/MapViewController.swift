//
//  MapViewController.swift
//  RunningApp
//
//  Created by Jesse Bartola on 7/14/17.
//  Copyright © 2017 runners. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    //let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //locationManager.requestWhenInUseAuthorization()
        print("f")
        //if CLLocationManager.locationServicesEnabled() {
        //    locationManager.delegate = self
        //    locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //    locationManager.startUpdatingLocation()
        //    locationManager.distanceFilter = 1000
        LocationService.sharedInstance.startUpdatingLocation()
        let coordinate = LocationService.sharedInstance.locationManager?.location?.coordinate
            
        mapView.showsUserLocation = true
        //mapView.mapType = MKMapType.hybrid
            
        centerMapOnLocation(coordinate: coordinate)
        
        
        addRightBarButton()
        addMapTrackingButton()
        mapView.delegate = self
        
    }
    
    func addMapTrackingButton() {
        let image = #imageLiteral(resourceName: "location")
        let button = UIButton(type: .system) as UIButton
        
        button.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.centerMapOnUserButtonClicked), for: .touchUpInside)
        self.mapView.addSubview(button)
    }
    
    func addRightBarButton() {
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "map_marker"), style: .plain, target: self, action: #selector(self.addLocation))
        
    }
    
    func centerMapOnUserButtonClicked() {
        self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
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
    
    func geocode(location: String, callback: @escaping (CLLocationCoordinate2D, CLLocationCoordinate2D) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in

            if error == nil {

                let placemark = placemarks?.first

                if let coordinate = placemark?.location?.coordinate {
                    //self.getRouteTo(destPlacemark: destPlacemark)
                    return callback((LocationService.sharedInstance.locationManager?.location?.coordinate)!, coordinate)
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
    
    func getRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let currentPlacemark = MKPlacemark(coordinate: from)
        let destPlacemark = MKPlacemark(coordinate: to)
        
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
            
            var boundingRectangle = route.polyline.boundingMapRect
            
            let anno = MKPointAnnotation()
            anno.coordinate = destPlacemark.coordinate
            anno.title = "Placemark"
            
            let span = MKCoordinateSpanMake(0.075, 0.075)
            let region = MKCoordinateRegion(center: anno.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(anno)
            self.mapView.selectAnnotation(anno, animated: true)
            self.mapView.setRegion(MKCoordinateRegionForMapRect(boundingRectangle), animated: true)
        })
        
    }
    
    func addLocation() {
        guard let location = LocationService.sharedInstance.locationManager?.location else {
            print("Could not retreive location coordinate...")
            return
        }
        
        let placemark = self.getAddressFor(location: location)
        //Locations.locations.append(location)
        //print(Locations.locations)
        
    }
    
    private func getAddressFor(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if let error = error {
                print("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                let pm = placemarks[0] as CLPlacemark
                guard let addresses = pm.addressDictionary else { return }
                
                guard let street = addresses["Street"], let state = addresses["State"], let zipcode = addresses["ZIP"] else { return }
                
                let streetAddress = String(describing: street) + " " + String(describing: state) + ", " + String(describing: zipcode)
                
                Locations.locations.append((streetAddress, location))
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
}



