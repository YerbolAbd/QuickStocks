//
//  Stock.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
//

import Foundation
import Alamofire


struct FinnhubStockResponse: Decodable {
    let currentPrice: Double
    let change: Double
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case change = "d"
    }
}


struct FinnhubProfileResponse: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct Stock: Decodable {
    let symbol: String
    let name: String
    let price: Double?
    let change: Double?
}
