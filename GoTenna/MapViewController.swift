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
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    @IBOutlet var mapView: MGLMapView!
    var pinData = [Pin]()
    var locationManager: CLLocationManager!
    @IBOutlet var viewModel: MapViewViewModel!
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
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        addMapMarkers()
    }
    func getData() {
        viewModel.fetchPins {
            DispatchQueue.main.async {
                self.addMapMarkers()
            }
        }
    }
    func addMapMarkers() {
        var points = [MGLPointAnnotation]()
        points = viewModel.getMapMarkers()
        for point in points {
            mapView.addAnnotation(point)
        }
    }
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
