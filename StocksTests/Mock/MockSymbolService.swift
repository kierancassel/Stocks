//
//  MockSymbolService.swift
//  StocksTests
//
//  Created by Kieran Cassel on 19/12/2022.
//

import Foundation
@testable import Stocks

class MockSymbolService: SymbolServicable {
    func getSymbols() -> [Symbol] {
        return []
    }
    func addSymbols(symbols: Symbols) {}
    func addStock(symbol: String, name: String, logoURL: String) {}
}
