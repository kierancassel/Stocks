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
    private let networkService = NetworkService()
    private var cancellables = Set<AnyCancellable>()

    init() {
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
        networkService.updateStock(stock: stock)
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
