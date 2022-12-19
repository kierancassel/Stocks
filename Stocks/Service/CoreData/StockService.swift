//
//  StockService.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation

protocol StockServicable {
    func getStocks() -> [Stock]
    func updateStocks(stockQuotes: [Stock: Quote])
    func deleteStock(stock: Stock)
    func moveStock(watchlist: [Stock], source: IndexSet, destination: Int)
}

extension StockServicable {
    func getStocks() -> [Stock] {
        return Stock.getStocks(moc: CoreDataManager.shared.container.viewContext)
    }
    func updateStocks(stockQuotes: [Stock: Quote]) {
        Stock.updateStocks(stockQuotes: stockQuotes)
        CoreDataManager.shared.save()
    }
    func deleteStock(stock: Stock) {
        Stock.deleteStock(stock: stock, moc: CoreDataManager.shared.container.viewContext)
        CoreDataManager.shared.save()
    }
    func moveStock(watchlist: [Stock], source: IndexSet, destination: Int) {
        Stock.moveStock(watchlist: watchlist, source: source, destination: destination)
        CoreDataManager.shared.save()
    }
}
class StockService: StockServicable {}
