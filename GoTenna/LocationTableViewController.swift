//
//  LocationTableViewController.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import UIKit
import CoreLocation
class LocationTableViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewModel: MapViewViewModel!
    var userLocation: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI() {
        self.title = "Menu"
        viewModel.getTableObjects {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PinTableViewCell else {
            return UITableViewCell()
        }
        let pin = viewModel.getPinForIndexPathRow(indexPath: indexPath)
        cell.setUp(pin: pin, location: viewModel.getDistance(userLocation: userLocation ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), locationLat: pin.latitude, locationLon: pin.longitude))
        return cell
    }
}
