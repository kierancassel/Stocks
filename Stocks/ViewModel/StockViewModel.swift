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
    @Published var error: Bool = false
    private let networkService: StockDataService
    private var cancellables = Set<AnyCancellable>()

    init(networkService: StockDataService) {
        self.networkService = networkService
        CoreDataService.shared.$watchlist
            .sink { [weak self] stocks in
                self?.watchlist = stocks
            }
            .store(in: &cancellables)
    }

    func updateStocks() {
        watchlist.forEach { updateStock(stock: $0) }
    }

    func updateStock(stock: Stock) {
        guard let symbol = stock.symbol else { return }
        networkService.updateStock(symbol: symbol)
            .sink { self.handleCompletion(completion: $0)}
             receiveValue: { quote in
                stock.price = NSDecimalNumber(string: quote.globalQuote.price)
                stock.change = NSDecimalNumber(string: quote.globalQuote.change)
                stock.changePercent = NSDecimalNumber(string: quote.globalQuote.changePercent)
                CoreDataService.shared.save()
            }.cancel()
    }

    func queryStocks(searchTerm: String) {
        networkService.queryStocks(searchTerm: searchTerm)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                    self.error = true
                }
            } receiveValue: { data in
                self.query = data
            }.cancel()
    }

    func handleCompletion(completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            print(error)
            self.error = true
        }
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
