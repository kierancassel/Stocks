//
//  SymbolService.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation

protocol SymbolServicable {
    func getSymbol() -> [Symbol]
    func addSymbols(symbols: Symbols)
    func addStock(symbol: String, name: String, logoURL: String)
}

extension SymbolServicable {
    func getSymbol() -> [Symbol] {
        Symbol.getSymbols(moc: CoreDataManager.shared.container.viewContext)
    }
    func addSymbols(symbols: Symbols) {
        Symbol.addSymbols(symbols: symbols, moc: CoreDataManager.shared.container.viewContext)
        CoreDataManager.shared.save()
    }
    func addStock(symbol: String, name: String, logoURL: String) {
        Stock.addStock(symbol: symbol, name: name, logoURL: logoURL,
                       moc: CoreDataManager.shared.container.viewContext)
    }
}
class SymbolService: SymbolServicable {}
