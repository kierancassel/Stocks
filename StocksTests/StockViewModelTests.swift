//
//  StockViewModelTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 09/10/2022.
//

import XCTest
@testable import Stocks

final class StockViewModelTests: XCTestCase {

    let stockDataService = MockStockDataService()
    var stockViewModel: StockViewModel!

    override func setUpWithError() throws {
        stockViewModel = StockViewModel(networkService: MockStockDataService())
    }

    func testQueryStocks() throws {
        stockViewModel.queryStocks(searchTerm: "test")
        XCTAssert(stockViewModel.query?.bestMatches[0].symbol == "AAPL")
        XCTAssert(stockViewModel.query?.bestMatches[0].name == "Apple Inc.")
        XCTAssert(stockViewModel.query?.bestMatches[1].symbol == "MSFT")
        XCTAssert(stockViewModel.query?.bestMatches[1].name == "Microsoft Corporation")
    }
}
