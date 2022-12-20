//
//  IEXServiceStockTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 20/12/2022.
//

import XCTest
@testable import Stocks

final class IEXServiceStockTests: XCTestCase {

    var iexService: IEXService!
    let networkManager = MockNetworkManager()
    let stockService = MockStockService()

    override func setUpWithError() throws {
        iexService = IEXService(networkManager: networkManager, stockService: stockService)
    }

    func testGetQuote() throws {
        var quote: Quote?
        let expectation = self.expectation(description: "Get Quote")
        iexService.getQuote(symbol: "AAPL")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            } receiveValue: { data in
                quote = data
            }.cancel()
        waitForExpectations(timeout: 1)
        XCTAssert(quote!.symbol == "AAPL")
        XCTAssert(quote!.latestPrice == 145.745)
    }
}
