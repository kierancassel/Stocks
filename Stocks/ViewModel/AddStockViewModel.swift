//
//  AddStockViewModel.swift
//  Stocks
//
//  Created by Kieran Cassel on 06/10/2022.
//

import Foundation
import Combine
import CoreData

class AddStockViewModel: ObservableObject {
    @Published var query: Query?
    private let networkService = NetworkService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        networkService.$query
            .sink { [weak self] query in
                self?.query = query
            }
            .store(in: &cancellables)
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
        networkService.updateStock(stock: stock)
    }
}
