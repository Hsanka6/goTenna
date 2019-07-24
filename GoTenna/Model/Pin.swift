//
//  Pin.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import RealmSwift

class PinRealm: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = 0
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var descriptionPin = ""
}

struct Pin: Decodable {
    let name: String
    let id: Int
    let latitude: Double
    let longitude: Double
    let description: String
}

struct Response: Decodable {
    var pins: [Pin]
}
