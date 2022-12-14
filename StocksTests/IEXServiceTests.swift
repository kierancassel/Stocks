//
//  IEXServiceTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 14/12/2022.
//

import XCTest
@testable import Stocks

final class IEXServiceTest: XCTestCase {

    let networkManager = MockNetworkManager()
    var iexService: IEXService!

    override func setUpWithError() throws {
        iexService = IEXService(networkManager: networkManager)
    }

    func testGetSymbols() throws {
        var symbols: Symbols?
        let expectation = self.expectation(description: "Get Symbols")
        iexService.getSymbols().sink { completion in
            if case let .failure(error) = completion {
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        } receiveValue: { data in
            symbols = data
        }.cancel()
        waitForExpectations(timeout: 1)
        XCTAssert(symbols!.count == 11515)
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

    func testGetLogo() throws {
        var logo: Logo?
        let expectation = self.expectation(description: "Get Logo")
        iexService.getLogo(symbol: "AAPL")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            } receiveValue: { data in
                logo = data
            }.cancel()
        waitForExpectations(timeout: 1)
        XCTAssert(logo!.url == "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png")
    }
}
