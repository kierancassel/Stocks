//
//  Stock+Extension.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation
import CoreData

extension Stock {
    static func addStock(symbol: String, name: String, logoURL: String, moc: NSManagedObjectContext) {
        let stock = Stock(context: moc)
        stock.symbol = symbol
        stock.name = name
        stock.logoURL = logoURL
    }
    static func deleteStock(stock: Stock, moc: NSManagedObjectContext) {
        moc.delete(stock)
    }
    static func getStocks(moc: NSManagedObjectContext) -> [Stock] {
        let request = Stock.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "userOrder", ascending: true)]
        do {
            return try moc.fetch(request)
        } catch {
            return []
        }
    }
    static func updateStocks(stockQuotes: [Stock: Quote]) {
        for (stock, quote) in stockQuotes {
            stock.price = quote.latestPrice ?? 0
            stock.change = quote.change ?? 0
            stock.changePercent = (quote.changePercent ?? 0) * 100
        }
    }
    static func moveStock(watchlist: [Stock], source: IndexSet, destination: Int) {
        var revisedWatchlist: [Stock] = watchlist.map { $0 }
        revisedWatchlist.move(fromOffsets: source, toOffset: destination )
        for reverseIndex in stride(from: revisedWatchlist.count - 1, through: 0, by: -1) {
            revisedWatchlist[reverseIndex].userOrder = Int16(reverseIndex)
        }
    }
}
