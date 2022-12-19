//
//  Symbol+Extension.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation
import CoreData

extension Symbol {
    static func addSymbols(symbols: Symbols, moc: NSManagedObjectContext) {
        symbols.forEach { element in
            let symbol = Symbol(context: moc)
            symbol.name = element.name
            symbol.symbol = element.symbol
        }
    }
    static func clearSymbols(moc: NSManagedObjectContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Symbol")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try moc.execute(deleteRequest)
        } catch {
            print("Error clearing symbols")
        }
    }
    static func getSymbols(moc: NSManagedObjectContext) -> [Symbol] {
        let request = Symbol.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "symbol", ascending: true)]
        do {
            return try moc.fetch(request)
        } catch {
            return []
        }
    }
    func symbolEntityMapper() -> SymbolEntity {
        return SymbolEntity(name: name ?? "", symbol: symbol ?? "")
    }
}
