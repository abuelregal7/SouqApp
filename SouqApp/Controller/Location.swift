//
//  Location.swift
//  SouqApp
//
//  Created by Ahmed.
//  Copyright © 2019 Ahmed. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Location: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    let location_manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPin(31, 31)
        location_manager.delegate = self
        location_manager.requestAlwaysAuthorization()
        location_manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        _ = loc.coordinate.latitude
        _ = loc.coordinate.longitude
        location_manager.stopUpdatingLocation()
        
    }
    
    func addPin(_ lat:Double,_ lng:Double){
        let point = MKPointAnnotation()
        point.title = "Khaled's location"
        point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        map.setRegion(region, animated: true)
        let pin = MKPinAnnotationView(annotation: point, reuseIdentifier: "id")
        map.addAnnotation(pin.annotation!)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
