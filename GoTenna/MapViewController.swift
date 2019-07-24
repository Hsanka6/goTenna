//
//  ViewController.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/23/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var mapView: MGLMapView!
    var locationManager: CLLocationManager!
    func setUpUI() {
        //mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last! as CLLocation
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        mapView.setCenter(center, animated: true)
//    }
//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation: CLLocation = locations.last else {
            return print("Can't find location")
        }
        mapView.setCenter(CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),zoomLevel: 12, animated: true)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error \(error)")
    }
}
