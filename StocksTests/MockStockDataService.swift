//
//  MockStockDataService.swift
//  StocksTests
//
//  Created by Kieran Cassel on 09/10/2022.
//

import Foundation
import Combine
@testable import Stocks

class MockStockDataService: StockDataService {
    func queryStocks(searchTerm: String) -> AnyPublisher<Query, Error> {
        let dummyQuery = Query(
            bestMatches: [
                BestMatch(symbol: "AAPL", name: "Apple Inc."),
                BestMatch(symbol: "MSFT", name: "Microsoft Corporation")
            ]
        )
        return Result.Publisher(dummyQuery).eraseToAnyPublisher()
    }

    func updateStock(symbol: String) -> AnyPublisher<Quote, Error> {
        let dummyQuote = Quote(
            globalQuote: GlobalQuote(
                symbol: "APPL",
                open: "100.00",
                high: "101.00",
                low: "99.00",
                price: "100.50",
                volume: "500000",
                change: "+0.50",
                changePercent: "+0.50%"
            )
        )
        return Result.Publisher(dummyQuote).eraseToAnyPublisher()
    }
}
