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
}
