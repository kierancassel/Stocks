//
//  IEXServiceTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 14/12/2022.
//

import XCTest
@testable import Stocks

final class IEXServiceTest: XCTestCase {

    var iexService: IEXService!
    let networkManager = MockNetworkManager()
    let symbolService = MockSymbolService()

    override func setUpWithError() throws {
        iexService = IEXService(networkManager: networkManager, symbolService: symbolService)
    }

    func testGetSymbols() throws {
        var symbols: [SymbolEntity]?
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
        XCTAssertEqual(symbols?.first?.name, "Prudential Financial Inc. - 5.95% NT REDEEM 01/09/2062 USD 25")
        XCTAssertEqual(symbols?.count, 11515)
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
