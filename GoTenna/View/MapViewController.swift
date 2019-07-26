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
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var mapView: MGLMapView!
    var pinData = [Pin]()
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
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
        }
    }
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        mapView.setCenter(annotation.coordinate, animated: true)
        titleLabel.isHidden = false
        subtitleLabel.isHidden = false
        guard let title = annotation.title else {
            return
        }
        titleLabel.text = title
        subtitleLabel.text = viewModel.getPinDescription(annotation: annotation)
    }
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // Optionally handle taps on the callout.
        print("Tapped the callout for: \(annotation)")
        // Hide the callout.
        mapView.deselectAnnotation(annotation, animated: true)
    }
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = true
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
        getData()
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
        self.userLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        mapView.setCenter(CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),zoomLevel: 14, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error \(error)")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menu" {
            if let controller = segue.destination as? LocationTableViewController {
                controller.userLocation = self.userLocation
            }
        }
    }
}
