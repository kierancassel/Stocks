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
    @Published var symbols: [Symbol] = []
    @Published var error: Bool = false
    private let dataService: StockDataService
    private var cancellables = Set<AnyCancellable>()

    init(dataService: StockDataService) {
        self.dataService = dataService
        CoreDataService.shared.$watchlist
            .sink { [weak self] watchlist in
                self?.watchlist = watchlist
            }
            .store(in: &cancellables)
        CoreDataService.shared.$symbols
            .sink { [weak self] symbols in
                self?.symbols = symbols
            }
            .store(in: &cancellables)
    }

    func getSymbols() {
        if symbols.isEmpty {
            dataService.getSymbols()
                .sink { self.handleCompletion(completion: $0) }
                receiveValue: {
                    CoreDataService.shared.storeSymbols(symbols: $0)
                }.cancel()
        } else {
            CoreDataService.shared.fetchSymbols()
        }
    }

    func searchSymbols(searchTerm: String) {
        CoreDataService.shared.filterSymbols(searchTerm: searchTerm)
    }

    func updateStocks() {
        var stockQuotes: [Stock: Quote] = [:]
        let updateGroup = DispatchGroup()
        watchlist.forEach { stock in
            updateGroup.enter()
            guard let symbol = stock.symbol else { return }
            dataService.getQuote(symbol: symbol)
                .sink { self.handleCompletion(completion: $0) }
                 receiveValue: {
                     stockQuotes[stock] = $0
                     updateGroup.leave()
                }.cancel()
        }
        updateGroup.notify(queue: .main) {
            CoreDataService.shared.updateStocks(stockQuotes: stockQuotes)
        }
    }

    func updateStock(stock: Stock) {
        guard let symbol = stock.symbol else { return }
        dataService.getQuote(symbol: symbol)
            .sink { self.handleCompletion(completion: $0) }
             receiveValue: {
                 CoreDataService.shared.updateStock(stock: stock, quote: $0)
            }.cancel()
    }

    func addStock(symbol: String, name: String) {
        dataService.getLogo(symbol: symbol)
            .sink { self.handleCompletion(completion: $0) }
            receiveValue: {
                let logoURL = $0.url
                CoreDataService.shared.addStock(symbol: symbol, name: name, logoURL: logoURL)
                self.updateStocks()
            }.cancel()
    }

    func moveStock(source: IndexSet, destination: Int) {
        CoreDataService.shared.moveStock(source: source, destination: destination)
    }

    func deleteStocks(offsets: IndexSet) {
        CoreDataService.shared.deleteStock(offsets: offsets)
    }

    private func handleCompletion(completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            print(error)
            self.error = true
        }
    }
}
