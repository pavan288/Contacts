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

    func getParamsString(params: [String: String]) -> String {
        var keyValueArray = [String]()
        for key in params.keys {
            let paramsString = key + "=" + (params[key]!)
            keyValueArray.append(paramsString)
        }
        return keyValueArray.joined(separator: "&")
    }

    func get(urlString: String, parameters: [String: String]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var requestUrl = urlString
        if let httpParams = parameters {
            let paramsString: String = getParamsString(params: httpParams)
            requestUrl = urlString + "?" + paramsString
        }
        guard let url = URL(string: requestUrl) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil, response, error)
                } else {
                    completion(data, response, nil)
                }
            }
        })
        task.resume()
    }

    func post(urlString: String, parameters: [String: String]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters as Any, options: [])
        request.httpBody = httpBody
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil, response, error)
                } else {
                    completion(data, response, nil)
                }
            }
        })
        task.resume()
    }

}
