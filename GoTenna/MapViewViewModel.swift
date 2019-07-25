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
class MapViewViewModel: NSObject {
    var pins = [Pin]()
    @IBOutlet weak var pinClient: PinClient!
    func fetchPins(completion: @escaping () -> Void) {
        pinClient.fetchData(completion: { pins in
            guard let pins = pins else {
                return
            }
            self.pins = pins
            self.storePinsInRealm(pins: pins)
            completion()
        })
    }
    func storePinsInRealm(pins: [Pin]) {
        print("storePins")
        do {
            let realm = try Realm()
            try realm.write {
                for pin in pins {
                    realm.create(PinRealm.self, value: [pin.name, pin.id, pin.latitude, pin.longitude, pin.description])
                }
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    func numberOfItemsInSection(section: Int) -> Int {
        return pins.count
    }
//    func titleFromItemAtIndexPath(indexPath: IndexPath) -> String {
//        return pins[indexPath.row].name
//    }
//
    func getMapMarkers() -> [MGLPointAnnotation] {
        var annotations = [MGLPointAnnotation]()
        for pin in pins {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            point.title = pin.name
            point.subtitle = pin.description
            annotations.append(point)
        }
        return annotations
    }
    func getPinForIndexPathRow(indexPath: IndexPath) -> Pin {
        return pins[indexPath.row]
    }
}
