//
//  StockViewModelTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 09/10/2022.
//

import XCTest
@testable import Stocks

final class StockViewModelTests: XCTestCase {

    var viewModel: StockViewModel!
    let dataService = MockStockDataService()

    override func setUpWithError() throws {
        viewModel = StockViewModel(dataService: dataService)
    }

    func testGetStocks() throws {
        XCTAssertEqual(viewModel.watchlist.count, 0)
        viewModel.getStocks()
        XCTAssertEqual(viewModel.watchlist.first?.name, "Apple Inc")
        XCTAssertEqual(viewModel.watchlist.count, 2)
    }
    func testUpdateStock() throws {
        XCTAssertEqual(viewModel.watchlist.count, 0)
        viewModel.getStocks()
        XCTAssertEqual(viewModel.watchlist.count, 2)
        XCTAssertEqual(viewModel.watchlist.first?.price, 99.0)
        viewModel.updateStocks()
        XCTAssertEqual(viewModel.watchlist.first?.price, 100.0)
    }
    func testMoveStock() throws {
        XCTAssertEqual(viewModel.watchlist.count, 0)
        viewModel.getStocks()
        XCTAssertEqual(viewModel.watchlist.count, 2)
        XCTAssertEqual(viewModel.watchlist[0].userOrder, 0)
        XCTAssertEqual(viewModel.watchlist[1].userOrder, 1)
        viewModel.moveStock(source: IndexSet([0]), destination: 2)
        XCTAssertEqual(viewModel.watchlist[0].userOrder, 1)
        XCTAssertEqual(viewModel.watchlist[1].userOrder, 0)
    }
    func testStockDelete() throws {
        XCTAssertEqual(viewModel.watchlist.count, 0)
        viewModel.getStocks()
        XCTAssertEqual(viewModel.watchlist.count, 2)
        viewModel.deleteStocks(offsets: IndexSet([0]))
        XCTAssertEqual(viewModel.watchlist.count, 1)
    }
}
