//
//  MapViewViewModel.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import Foundation

class MapViewViewModel: NSObject {
    var pins = [Pin]()
    @IBOutlet weak var pinClient: PinClient!
    func fetchPins(completion: @escaping () -> Void) {
        pinClient.fetchData(completion: { pins in
            guard let pins = pins else {
                return
            }
            self.pins = pins
            completion()
        })
    }
    func numberOfItemsInSection(section: Int) -> Int {
        return pins.count
    }
//    func titleFromItemAtIndexPath(indexPath: IndexPath) -> String {
//        return pins[indexPath.row].name
//    }
//
    func getPinForIndexPathRow(indexPath: IndexPath) -> Pin {
        return pins[indexPath.row]
    }
}
