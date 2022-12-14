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
    func getSymbols() -> AnyPublisher<Symbols, Error> {
        let dummySymbols = Symbols(
            [SymbolElement(symbol: "AAPL", name: "Apple Inc", date: "2022-12-14", isEnabled: true),
             SymbolElement(symbol: "MSFT", name: "Microsoft Corporation", date: "2022-12-14", isEnabled: true),
             SymbolElement(symbol: "GOOGL", name: "Alphabet Inc - Class A", date: "2022-12-14", isEnabled: true),
             SymbolElement(symbol: "AMZN", name: "Amazon.com Inc.", date: "2022-12-14", isEnabled: true)])
        return Result.Publisher(dummySymbols).eraseToAnyPublisher()
    }

    func getQuote(symbol: String) -> AnyPublisher<Quote, Error> {
        let dummyQuote = Quote(
            avgTotalVolume: nil,
            calculationPrice: nil,
            change: 1,
            changePercent: 0.01,
            closeSource: nil,
            companyName: nil,
            currency: nil,
            iexClose: nil,
            iexCloseTime: nil,
            iexOpen: nil,
            iexOpenTime: nil,
            lastTradeTime: nil,
            latestPrice: 100,
            latestSource: nil,
            latestTime: nil,
            latestUpdate: nil,
            marketCap: nil,
            openSource: nil,
            peRatio: nil,
            previousClose: nil,
            previousVolume: nil,
            primaryExchange: nil,
            symbol: nil,
            week52High: nil,
            week52Low: nil,
            ytdChange: nil,
            isUSMarketOpen: nil
        )
        return Result.Publisher(dummyQuote).eraseToAnyPublisher()
    }

    func getLogo(symbol: String) -> AnyPublisher<Logo, Error> {
        let dummyLogo = Logo(url: "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png")
        return Result.Publisher(dummyLogo).eraseToAnyPublisher()
    }
}
