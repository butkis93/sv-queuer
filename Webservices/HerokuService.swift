//
//  HerokuService.swift
//  SV Queuer
//
//  Created by Nicholas LoBue on 1/29/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import UIKit

typealias SuccessBlock = (Decodable?, URLResponse?) -> ()
typealias ErrorBlock = (Error) -> ()

class HerokuService {
    class func send<T : Decodable>(with request: HerokuRequest, responseType: T.Type, onSuccess: @escaping SuccessBlock, onFail: @escaping ErrorBlock) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        if let urlRequest = request.urlRequest {
            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    onFail(error)
                } else if let data = data {
                    let decodable = try? JSONDecoder().decode(T.self, from: data)
                    onSuccess(decodable, response)
                }
            }.resume()
        }
    }
}
