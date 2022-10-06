//
//  Quote.swift
//  Stocks
//
//  Created by Kieran Cassel on 04/10/2022.
//

import Foundation

struct Quote: Codable {
    let globalQuote: GlobalQuote

    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}

struct GlobalQuote: Codable {
    let symbol, open, high, low: String
    let price, volume: String
    let change, changePercent: String

    enum CodingKeys: String, CodingKey {
        case symbol = "01. symbol"
        case open = "02. open"
        case high = "03. high"
        case low = "04. low"
        case price = "05. price"
        case volume = "06. volume"
        case change = "09. change"
        case changePercent = "10. change percent"
    }
}
