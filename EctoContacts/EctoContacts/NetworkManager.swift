//
//  NetworkManager.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    static let baseURL = "http://167.172.6.138:8080"

    private init() {}

    func get(urlString: String, parameters: [String: Any]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data else { return }
            if error != nil {
                completion(nil, response, error)
            } else {
                completion(data, response, nil)
            }
        })
        task.resume()
    }
}
