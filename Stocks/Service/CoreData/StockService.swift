//
//  StockService.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation

protocol StockServicable {
    func getStocks() -> [Stock]
    func updateStocks()
    func deleteStock(stock: Stock)
    func moveStock()
}

extension StockServicable {
    func getStocks() -> [Stock] {
        return Stock.getStocks(moc: CoreDataManager.shared.container.viewContext)
    }
    func updateStocks() {
        CoreDataManager.shared.save()
    }
    func deleteStock(stock: Stock) {
        Stock.deleteStock(stock: stock, moc: CoreDataManager.shared.container.viewContext)
        CoreDataManager.shared.save()
    }
    func moveStock() {
        CoreDataManager.shared.save()
    }
}
class StockService: StockServicable {}
