//
//  CoreDataManagerTests.swift
//  StocksTests
//
//  Created by Kieran Cassel on 20/12/2022.
//

import XCTest
import CoreData
@testable import Stocks

final class CoreDataManagerTests: XCTestCase {

    var manager: CoreDataManager!

    override func setUpWithError() throws {
        manager = CoreDataManager.preview
    }

    func testInit() throws {
        let instance = manager
        XCTAssertNotNil(instance)
    }

    func testPersistentContainer() throws {
        let container = manager.container
        XCTAssertNotNil(container)
    }

    func testSave() throws {
        let context = manager.container.viewContext
        let stock = Stock(context: context)
        stock.symbol = "AAPL"
        stock.name = "Apple Inc"
        stock.logoURL = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png"
        stock.price = 99.0
        stock.userOrder = 0
        stock.changePercent = 1.0
        manager.save()
        let result = Stock.getStocks(moc: context)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Apple Inc")
        context.delete(stock)
    }

    func testPreviewStock() throws {
        let context = manager.container.viewContext
        let stock = CoreDataManager.previewStock
        let result = Stock.getStocks(moc: context)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Apple Inc")
        context.delete(stock)
    }
}
