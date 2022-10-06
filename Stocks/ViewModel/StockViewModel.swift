//
//  StockViewModel.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import Foundation
import CoreData

class StockViewModel: ObservableObject {
    private var networkManager: NetworkManager
    @Published var stocks: [Stock] = []
    @Published var query: Query?

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func getStocks() {
        let context = PersistenceController.shared.container.viewContext
        let request = Stock.fetchRequest()
        do {
            stocks = try context.fetch(request)
        } catch { print(error) }
    }

    func queryStocks(searchTerm: String) async {
        let url: String = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=" + searchTerm
        + "&apikey=" + APIKey.key.rawValue
        do {
            let data = try await networkManager.get(url: url)
            do {
                let query = try JSONDecoder().decode(Query.self, from: data)
                DispatchQueue.main.async {
                    self.query = query
                }
            } catch { print("Error parsing JSON") }
        } catch { print(error) }
    }

    func updateStock(stock: Stock) async {
        guard let symbol = stock.symbol else { return }
        let url: String = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + symbol
        + "&apikey=" + APIKey.key.rawValue
        var quote: Quote?
        do {
            let data = try await networkManager.get(url: url)
            do {
                quote = try JSONDecoder().decode(Quote.self, from: data)
            } catch { print("Error parsing JSON") }
        } catch { print(error) }
        if let quote {
            stock.price = NSDecimalNumber(string: quote.globalQuote.price)
            stock.change = NSDecimalNumber(string: quote.globalQuote.change)
            stock.changePercent = NSDecimalNumber(string: quote.globalQuote.changePercent)
        }
        PersistenceController.shared.saveContext()
    }

    func updateStocks() {
        stocks.forEach { stock in
            DispatchQueue.main.async {
                Task {
                    await self.updateStock(stock: stock)
                }
            }
        }
    }

    func addStock(symbol: String, name: String) async {
        let context = PersistenceController.shared.container.viewContext
        guard let stock = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: context) as? Stock
        else { return }
        stock.symbol = symbol
        stock.name = name
        await updateStock(stock: stock)
        getStocks()
    }

    func deleteStocks(offsets: IndexSet) {
        let context = PersistenceController.shared.container.viewContext
        offsets.forEach {
            let stock = stocks[$0]
            context.delete(stock)
            PersistenceController.shared.saveContext()
        }
        getStocks()
    }
}
