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
    func updateStocks() {}
    func deleteStock(stock: Stock) {}
    func getStocks() -> [Stock] {
        let stock1 = Stock(context: CoreDataManager.shared.container.viewContext)
        stock1.symbol = "AAPL"
        stock1.name = "Apple Inc"
        stock1.logoURL = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png"
        stock1.price = 99.0
        stock1.userOrder = 0
        stock1.changePercent = 1.0
        let stock2 = Stock(context: CoreDataManager.shared.container.viewContext)
        stock2.symbol = "MSFT"
        stock2.name = "Microsoft Corporation"
        stock2.logoURL = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/MSFT.png"
        stock2.price = 200.0
        stock2.userOrder = 1
        stock2.changePercent = 3.0
        return [stock1, stock2]
    }
    func moveStock() {}
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
}
