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
    
    var directions = false
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationService.sharedInstance.startUpdatingLocation()
        let coordinate = LocationService.sharedInstance.locationManager?.location?.coordinate
            
        mapView.showsUserLocation = true
        //mapView.mapType = MKMapType.hybrid
            
        centerMapOnLocation(coordinate: coordinate)
        
        addLeftBarButton()
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
        button.tintColor = Styles.color(style: .lightBlue)
        button.addTarget(self, action: #selector(self.centerMapOnUserButtonClicked), for: .touchUpInside)
        self.mapView.addSubview(button)
    }
    
    func addLeftBarButton() {
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "restart"), style: .plain, target: self, action: #selector(self.clearMap))
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
                    return callback(coordinate, coordinate)
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
    
    func getRouteTo(location: Location, callback: @escaping () -> Void) {
        guard let coord = LocationService.sharedInstance.locationManager?.location?.coordinate else {
            print("Could not find a current Location...")
            return
            
        }
        let currentPlacemark = MKPlacemark(coordinate: coord)
        let destPlacemark = MKPlacemark(coordinate: location.location.coordinate)
        
        let currentItem = MKMapItem(placemark: currentPlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = currentItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
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
            self.mapView.add(route.polyline, level: .aboveRoads)
            self.removeAnnotations()
            
            var boundingRectangle = route.polyline.boundingMapRect
            
            let anno = MKPointAnnotation()
            anno.coordinate = destPlacemark.coordinate
            anno.title = location.name != nil ? location.name! : Util.parseDate(date: location.date)
            
            let span = MKCoordinateSpanMake(0.075, 0.075)
            let region = MKCoordinateRegion(center: anno.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(anno)
            self.mapView.selectAnnotation(anno, animated: true)
            self.mapView.setRegion(MKCoordinateRegionForMapRect(boundingRectangle), animated: true)
            
            // Set 'directions' to true so we know that the map is currently displaying a direction
            self.directions = true
            
            callback()
            
        })
        
    }
    
    func clearMap() {
        self.removeDirections()
        self.removeAnnotations()
    }
    
    func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func removeDirections() {
        if mapView.overlays.count > 0 {
            mapView.remove(mapView.overlays[0])
        }
        
        removeAnnotations()
    }
    
    func addLocation() {
        guard let location = LocationService.sharedInstance.locationManager?.location else {
            print("Could not retreive location coordinate...")
            return
        }
        
        self.getAddressFor(location: location)
        
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
                let newLocation = Location(date: Date(), location: location, name: nil, address: streetAddress)
                Locations.locations.append(newLocation)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
}



