//
//  GoTennaTests.swift
//  GoTennaTests
//
//  Created by Haasith Sanka on 7/23/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import XCTest
import CoreLocation
@testable import GoTenna

class GoTennaTests: XCTestCase {

    override func setUp() {
        let loc: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 25, longitude: 25)
        XCTAssertEqual(String(format: "%.1f",loc.getDistanceInMiles(userLocation: loc, locationLat: 26.0, locationLon: 26.0)), "93.0")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
