//
//  Request.swift
//  SV Queuer
//
//  Created by Nicholas LoBue on 1/29/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import UIKit

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

class HerokuRequest {
    var urlRequest: URLRequest?
    
    init(path: String, httpMethod: HttpMethod) {
        if let url = URL(string: StringConstants.baseUrl + path) {
            self.urlRequest = URLRequest(url: url)
            configureRequest(for: httpMethod)
        }
    }
    
    init<T : Encodable>(path: String, httpBody: T, httpMethod: HttpMethod) {
        if let url = URL(string: StringConstants.baseUrl + path) {
            self.urlRequest = URLRequest(url: url)
            configureRequest(for: httpMethod)
            configureBody(with: httpBody)
        }
    }
    
    private func configureRequest(for httpMethod: HttpMethod) {
        if let apiKey = UserDefaults.standard.string(forKey: "apiKey") {
            urlRequest?.addValue(apiKey, forHTTPHeaderField: "X-Qer-Authorization")
        }
        urlRequest?.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest?.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest?.httpMethod = httpMethod.rawValue
    }
    
    private func configureBody<T : Encodable>(with httpBody: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let encodedData = try? encoder.encode(httpBody)
        urlRequest?.httpBody = encodedData
    }
}
