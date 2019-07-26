//
//  MapViewViewModel.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import Foundation
import RealmSwift
import Mapbox
import CoreLocation
class MapViewViewModel: NSObject {
    var pins = [Pin]()
    @IBOutlet weak var pinClient: PinClient!
    func fetchPins(completion: @escaping () -> Void) {
        pinClient.fetchData(completion: { pins in
            guard let pins = pins else {
                return
            }
            self.pins = pins
            self.storePinsInRealm()
            completion()
        })
    }
    func getTableObjects(completion: @escaping () -> Void) {
        do {
            let realm = try Realm()
            let objects = realm.objects(PinRealm.self)
            if objects.count > 0 {
                completion()
            } else {
                print("Objects not stored in Realm")
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    func getPinDescription(annotation: MGLAnnotation) -> String {
        guard let pin = pins.first(where: {$0.name == annotation.title}) else {
            return ""
        }
        return pin.description
    }
    func storePinsInRealm() {
        do {
            let realm = try Realm()
            try realm.write {
                for pin in pins {
                    let pinThatExists = realm.objects(PinRealm.self).filter("id = %@", pin.id)
                    if pinThatExists.count == 0 {
                         realm.create(PinRealm.self, value: [pin.name, pin.id, pin.latitude, pin.longitude, pin.description])
                    }
                }
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    func numberOfItemsInSection(section: Int) -> Int {
        do {
            let realm = try Realm()
            let objects = realm.objects(PinRealm.self)
            return objects.count
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return 0
    }
    func getMapMarkers() -> [MGLPointAnnotation] {
        var annotations = [MGLPointAnnotation]()
        for pin in pins {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            point.title = pin.name
            annotations.append(point)
        }
        return annotations
    }
    func getDistance(userLocation: CLLocationCoordinate2D, locationLat: Double, locationLon: Double) -> Double {
        var distance = 0.0
        let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let placeLocation = CLLocation(latitude: locationLat, longitude: locationLon)
        let distanceInMeters = userLocation.distance(from: placeLocation)
        distance = distanceInMeters/1609.0
        return distance
    }
    func getPinForIndexPathRow(indexPath: IndexPath) -> Pin {
        do {
            let realm = try Realm()
            guard let specificPerson = realm.object(ofType: PinRealm.self, forPrimaryKey: indexPath.row + 1) else {
                return Pin()
            }
            return Pin(name: specificPerson.name, id: specificPerson.id, lat: specificPerson.latitude, lon: specificPerson.longitude, description: specificPerson.descriptionPin)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        return Pin()
    }
}
