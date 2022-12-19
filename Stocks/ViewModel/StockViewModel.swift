//
//  StockViewModel.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import Foundation
import Combine

class StockViewModel: ObservableObject {
    @Published var watchlist: [Stock] = []
    @Published var error: Bool = false
    private let dataService: StockDataService

    init(dataService: StockDataService) {
        self.dataService = dataService
    }
    func getStocks() {
        watchlist = dataService.getStocks()
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
            self.dataService.updateStocks(stockQuotes: stockQuotes)
        }
    }
    func moveStock(source: IndexSet, destination: Int) {
        dataService.moveStock(watchlist: watchlist, source: source, destination: destination)
    }
    func deleteStocks(offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let stock = watchlist[index]
        dataService.deleteStock(stock: stock)
    }

    private func handleCompletion(completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            print(error)
            self.error = true
        }
    }
}
