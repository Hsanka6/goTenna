//
//  LocationTableViewController.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import UIKit

class LocationTableViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewModel: MapViewViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchPins {
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
        cell.setUp(pin: viewModel.getPinForIndexPathRow(indexPath: indexPath))
        return cell
    }
}
