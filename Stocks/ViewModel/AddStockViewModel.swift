//
//  AddStockViewModel.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation
import Combine

class AddStockViewModel: ObservableObject {
    @Published var symbols: [SymbolEntity] = []
    @Published var searchTerm = ""
    @Published var error: Bool = false
    private let dataService: SymbolDataService
    private var cancellables = Set<AnyCancellable>()
    init(dataService: SymbolDataService) {
        self.dataService = dataService
    }
    func getSymbols() {
        dataService.getSymbols()
            .sink { self.handleCompletion(completion: $0) }
            receiveValue: {
                self.symbols = $0
            }.cancel()
    }
    func getFilteredSymbols() -> [SymbolEntity] {
        if !searchTerm.isEmpty {
            let filteredSymbols = symbols.filter { symbol in
                if symbol.name.range(of: searchTerm, options: .caseInsensitive) != nil ||
                    symbol.symbol.range(of: searchTerm, options: .caseInsensitive) != nil {
                    return true
                }
                return false
            }
            return filteredSymbols
        }
        return symbols
    }
    func addStock(symbol: String, name: String) {
        dataService.getLogo(symbol: symbol)
            .sink { self.handleCompletion(completion: $0) }
        receiveValue: {
            self.dataService.addStock(symbol: symbol, name: name, logoURL: $0.url)
        }.cancel()
    }
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        if case let .failure(error) = completion {
            print(error)
            self.error = true
        }
    }
}
