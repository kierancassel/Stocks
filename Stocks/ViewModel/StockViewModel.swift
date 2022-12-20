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
        let updateGroup = DispatchGroup()
        watchlist.forEach { stock in
            updateGroup.enter()
            guard let symbol = stock.symbol else { return }
            dataService.getQuote(symbol: symbol)
                .sink { self.handleCompletion(completion: $0) }
            receiveValue: {
                stock.price = $0.latestPrice ?? 0
                stock.change = $0.change ?? 0
                stock.changePercent = ($0.changePercent ?? 0) * 100
                updateGroup.leave()
            }.cancel()
        }
        updateGroup.notify(queue: .main) {
            self.dataService.updateStocks()
        }
    }
    func moveStock(source: IndexSet, destination: Int) {
        var revisedWatchlist: [Stock] = watchlist.map { $0 }
        revisedWatchlist.move(fromOffsets: source, toOffset: destination )
        for reverseIndex in stride(from: revisedWatchlist.count - 1, through: 0, by: -1) {
            revisedWatchlist[reverseIndex].userOrder = Int16(reverseIndex)
        }
        dataService.moveStock()
    }
    func deleteStocks(offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let stock = watchlist[index]
        watchlist.remove(at: index)
        dataService.deleteStock(stock: stock)
    }

    private func handleCompletion(completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            print(error)
            self.error = true
        }
    }
}
