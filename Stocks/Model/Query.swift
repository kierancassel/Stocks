//
//  Query.swift
//  Stocks
//
//  Created by Kieran Cassel on 04/10/2022.
//

import Foundation

struct Query: Codable {
    let bestMatches: [BestMatch]
}

struct BestMatch: Codable, Identifiable {
    let id = UUID()
    let symbol, name: String

    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
    }
}
