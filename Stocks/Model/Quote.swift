//
//  Quote.swift
//  Stocks
//
//  Created by Kieran Cassel on 13/12/2022.
//

import Foundation

struct Quote: Codable {
    let avgTotalVolume: Int?
    let calculationPrice: String?
    let change, changePercent: Double?
    let closeSource: String?
    let companyName, currency: String?
    let iexClose: Double?
    let iexCloseTime: Int?
    let iexOpen: Double?
    let iexOpenTime: Int?
    let lastTradeTime: Int?
    let latestPrice: Double
    let latestSource, latestTime: String?
    let latestUpdate: Int?
    let marketCap: Int?
    let openSource: String?
    let peRatio, previousClose: Double?
    let previousVolume: Int?
    let primaryExchange, symbol: String?
    let week52High, week52Low, ytdChange: Double?
    let isUSMarketOpen: Bool?
}
