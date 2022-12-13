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

    init(networkService: StockDataService) {
        self.dataService = networkService
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
                .sink { completion in
                    if case let .failure(error) = completion {
                        print(error)
                        self.error = true
                    }
                } receiveValue: { data in
                    CoreDataService.shared.storeSymbols(symbols: data)
                }.cancel()
        }
    }

    func searchSymbols(searchTerm: String) {
        CoreDataService.shared.filterSymbols(searchTerm: searchTerm)
    }

    func updateStocks() {
        watchlist.forEach { updateStock(stock: $0) }
    }

    func updateStock(stock: Stock) {
        guard let symbol = stock.symbol else { return }
        dataService.getQuote(symbol: symbol)
            .sink { self.handleCompletion(completion: $0)}
             receiveValue: { quote in
                 CoreDataService.shared.update(stock: stock, quote: quote)
            }.cancel()
    }

    func handleCompletion(completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            print(error)
            self.error = true
        }
    }

    func addStock(symbol: String, name: String) {
        dataService.getLogo(symbol: symbol)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                    self.error = true
                }
            } receiveValue: { data in
                let logoURL = data.url
                CoreDataService.shared.add(symbol: symbol, name: name, logoURL: logoURL)
            }.cancel()
    }

    func moveStock(source: IndexSet, destination: Int) {
        CoreDataService.shared.move(source: source, destination: destination)
    }

    func deleteStocks(offsets: IndexSet) {
        CoreDataService.shared.delete(offsets: offsets)
    }
}
