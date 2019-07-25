//
//  PinClient.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/24/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import Foundation

class PinClient: NSObject {
    func fetchData(completion: @escaping ([Pin]?) -> Void) {
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
                completion(pinData)
            } catch let err {
                print(err)
            }
            }.resume()
    }
}
