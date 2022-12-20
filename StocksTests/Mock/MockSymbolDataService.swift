//
//  MockSymbolDataService.swift
//  StocksTests
//
//  Created by Kieran Cassel on 19/12/2022.
//

import Foundation
import Combine
@testable import Stocks

class MockSymbolDataService: SymbolDataService {
    func getSymbols() -> AnyPublisher<[SymbolEntity], Error> {
        let dummySymbols = [SymbolEntity(name: "Apple Inc", symbol: "AAPL"),
                            SymbolEntity(name: "Microsoft Corporation", symbol: "MSFT"),
                            SymbolEntity(name: "Alphabet Inc - Class A", symbol: "GOOGL"),
                            SymbolEntity(name: "Amazon.com Inc.", symbol: "AMZN")]
        return Result.Publisher(dummySymbols).eraseToAnyPublisher()
    }
    func getLogo(symbol: String) -> AnyPublisher<Logo, Error> {
        let dummyLogo = Logo(url: "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png")
        return Result.Publisher(dummyLogo).eraseToAnyPublisher()
    }
    func addStock(symbol: String, name: String, logoURL: String) {

    }
}
