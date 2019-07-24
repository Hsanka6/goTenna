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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var mapView: MGLMapView!
    var pinData = [Pin]()
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
    func addData() {
//        let realm = try! Realm()
//        try! realm.write() {
//            //let response = try decoder.decode(Response.self, from: getFile(fileName: "goTenna"))
//            //self.siteArray = response.sites
//            var person = realm.create(Pin.self, value: ["Jane", 27])
//            // Reading from or modifying a `RealmOptional` is done via the `value` property
//        }
        //let res: Response = getFile(fileName: "goTenna")
//        for pin in res.pins {
//            print(pin.name)
//        }
        getFile()
    }
    func getFile() {
        let jsonURL = "https://annetog.gotenna.com/development/scripts/get_map_pins.php"
        guard let url = URL(string: jsonURL ) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data,response,error) -> Void in
            guard let data = data else { return }
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let pinData = try decoder.decode([Pin].self, from: data)
                self.pinData = pinData
            } catch let err {
                print(err)
            }
        }.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addData()
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
