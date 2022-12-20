//
//  AddStockViewModelTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 19/12/2022.
//

import XCTest
@testable import Stocks

final class AddStockViewModelTests: XCTestCase {

    var viewModel: AddStockViewModel!
    let dataService = MockSymbolDataService()

    override func setUpWithError() throws {
        viewModel = AddStockViewModel(dataService: dataService)
    }

    func testGetSymbols() throws {
        XCTAssertEqual(viewModel.symbols.count, 0)
        viewModel.getSymbols()
        XCTAssertEqual(viewModel.symbols.count, 4)
    }
    func testGetFilteredSymbols() throws {
        XCTAssertEqual(viewModel.symbols.count, 0)
        viewModel.getSymbols()
        viewModel.searchTerm = ""
        XCTAssertEqual(viewModel.getFilteredSymbols().count, 4)
        viewModel.searchTerm = "Apple"
        XCTAssertEqual(viewModel.getFilteredSymbols().count, 1)
        viewModel.searchTerm = "MSFT"
        XCTAssertEqual(viewModel.getFilteredSymbols().count, 1)
    }
}
