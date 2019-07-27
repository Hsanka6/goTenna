# GoTenna iOS Map Application

[![Swift Version][swift-image]][swift-url]

## Overview

This app displays pins on a Mapbox map and menu and in the menu it shows how many miles the location is away from the user's current location in miles. If you click on a pin, it centers the map around the clicked pin.

This application uses the MVVM architecture and took me 8 hours to complete.

## Requirements

- iOS 12.0+
- Xcode 10.0+
- Swift 5

## Installation

Download the repository and click run.

## Bonus Features
1. Stored the pin data in Realm
2. Added extension to CLLocationCoordinate2d to calculate distance each place is away from the user's current location in miles
3. Added a XCTest to test my extension function above in bonus feature 2.
4. Organized models, viewmodels, views, extensions and client in separate folders. 
5. The user can click on a pin and it centers the map based on the pin 
6. Used guard let instead of if let to avoid crashes and terminate earlier.
7. Used Swiftlinter to have better swift standards

## Third Party Libraries Used
1. Realm
2. Mapbox
3. SwiftLint

## Creator

Haasith Sanka
https://github.com/Hsanka6

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
