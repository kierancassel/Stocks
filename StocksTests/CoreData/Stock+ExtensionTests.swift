//
//  Stock+ExtensionTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 20/12/2022.
//

import XCTest
@testable import Stocks

final class StockExtensionTests: XCTestCase {

    var manager: CoreDataManager!

    override func setUpWithError() throws {
        manager = CoreDataManager.preview
        Stock.addStock(
            symbol: "AAPL",
            name: "Apple Inc",
            logoURL: "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png",
            moc: manager.container.viewContext)
        manager.save()
    }

    func testAddStock() throws {
        let context = manager.container.viewContext
        let result = Stock.getStocks(moc: context)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Apple Inc")
        if let stock = result.first {
            context.delete(stock)
        }
    }
    func testDeleteStock() throws {
        let context = manager.container.viewContext
        let result = Stock.getStocks(moc: context)
        XCTAssertNotNil(result.first)
        if let stock = result.first {
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.first?.name, "Apple Inc")
            Stock.deleteStock(stock: stock, moc: context)
            let result = Stock.getStocks(moc: context)
            XCTAssertEqual(result.count, 0)
        }
    }
    func testGetStocks() throws {
        let context = manager.container.viewContext
        let result = Stock.getStocks(moc: context)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Apple Inc")
    }
}
