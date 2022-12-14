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
        stockViewModel = StockViewModel(dataService: stockDataService)
    }

    func testGetSymbols() throws {
        stockViewModel.getSymbols()
        XCTAssert(stockViewModel.symbols[0].symbol == "AAPL")
        XCTAssert(stockViewModel.symbols[0].name == "Apple Inc")
    }

    func testSearchSymbols() throws {
        stockViewModel.searchSymbols(searchTerm: "Apple")
        XCTAssert(stockViewModel.symbols.count == 1)
    }
}
