//
//  StockViewModel.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import Foundation
import Combine
import CoreData

class StockViewModel: ObservableObject {
    @Published var watchlist: [Stock] = []
    @Published var query: Query?
    private let networkService = NetworkService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        CoreDataService.shared.$watchlist
            .sink { [weak self] stocks in
                self?.watchlist = stocks
            }
            .store(in: &cancellables)
        networkService.$query
            .sink { [weak self] query in
                self?.query = query
            }
            .store(in: &cancellables)
    }

    func updateStocks() {
        watchlist.forEach { updateStock(stock: $0) }
    }

    func updateStock(stock: Stock) {
        networkService.updateStock(stock: stock) { data, response, error in
            if let error {
                print(error)
                return
            }
            guard let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 &&
                    response.statusCode < 300 else {
                print("Bad response")
                return
            }
            if let data {
                do {
                    let quote = try JSONDecoder().decode(Quote.self, from: data)
                    stock.price = NSDecimalNumber(string: quote.globalQuote.price)
                    stock.change = NSDecimalNumber(string: quote.globalQuote.change)
                    stock.changePercent = NSDecimalNumber(string: quote.globalQuote.changePercent)
                } catch { print("Error parsing JSON") }
            }
            DispatchQueue.main.async {
                CoreDataService.shared.save()
            }
        }
    }

    func queryStocks(searchTerm: String) {
        networkService.queryStocks(searchTerm: searchTerm)
    }

    func addStock(symbol: String, name: String) {
        let context = CoreDataService.shared.container.viewContext
        guard let stock = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: context) as? Stock
        else { return }
        stock.symbol = symbol
        stock.name = name
        updateStock(stock: stock)
    }

    func moveStock(source: IndexSet, destination: Int) {
        var revisedWatchlist: [Stock] = watchlist.map { $0 }
        revisedWatchlist.move(fromOffsets: source, toOffset: destination )
        for reverseIndex in stride(from: revisedWatchlist.count - 1, through: 0, by: -1) {
            revisedWatchlist[reverseIndex].userOrder = Int16(reverseIndex)
        }
        CoreDataService.shared.save()
    }

    func deleteStocks(offsets: IndexSet) {
        let context = CoreDataService.shared.container.viewContext
        offsets.forEach {
            let stock = watchlist[$0]
            context.delete(stock)
            CoreDataService.shared.save()
        }
    }
}
