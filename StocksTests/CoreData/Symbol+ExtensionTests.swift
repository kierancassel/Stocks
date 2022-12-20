//
//  Symbol+ExtensionTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 20/12/2022.
//

import XCTest
@testable import Stocks

final class SymbolExtensionTests: XCTestCase {

    var manager: CoreDataManager!

    override func setUpWithError() throws {
        manager = CoreDataManager.preview
        let dummySymbols = Symbols(
                    [SymbolElement(
                        symbol: "AAPL", name: "Apple Inc", date: "2022-12-14", isEnabled: true),
                     SymbolElement(
                        symbol: "MSFT", name: "Microsoft Corporation", date: "2022-12-14", isEnabled: true),
                     SymbolElement(
                        symbol: "GOOGL", name: "Alphabet Inc - Class A", date: "2022-12-14", isEnabled: true),
                     SymbolElement(
                        symbol: "AMZN", name: "Amazon.com Inc.", date: "2022-12-14", isEnabled: true)])
        Symbol.addSymbols(symbols: dummySymbols, moc: manager.container.viewContext)
        manager.save()
    }

    func testAddSymbols() throws {
        let context = manager.container.viewContext
        let result = Symbol.getSymbols(moc: context)
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result.first?.name, "Apple Inc")
    }
    func testClearSymbols() throws {
        let context = manager.container.viewContext
        Symbol.clearSymbols(moc: context)
        let result = Symbol.getSymbols(moc: context)
        XCTAssertEqual(result.count, 0)
    }
    func testGetSymbols() throws {
        let context = manager.container.viewContext
        let result = Symbol.getSymbols(moc: context)
        XCTAssertEqual(result.count, 4)
    }
}
