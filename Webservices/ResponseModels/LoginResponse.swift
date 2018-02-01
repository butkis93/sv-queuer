//
//  LoginResponse.swift
//  SV Queuer
//
//  Created by Nicholas LoBue on 1/30/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

struct LoginResponse: Decodable {
    let apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
