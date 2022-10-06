//
//  DataService.swift
//  Stocks
//
//  Created by Kieran Cassel on 06/10/2022.
//

import Foundation
import Combine

class NetworkService {
    @Published var query: Query?

    var subscription: AnyCancellable?

    func queryStocks(searchTerm: String) {
        let urlString: String = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=" + searchTerm
        + "&apikey=" + APIKey.key.rawValue
        guard let url = URL(string: urlString) else { return }

        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .decode(type: Query.self, decoder: JSONDecoder())
            .sink { _ in } receiveValue: { [weak self] query in
                self?.query = query
                self?.subscription?.cancel()
            }
    }

    func updateStock(stock: Stock) {
        guard let symbol = stock.symbol else { return }
        let urlString: String = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + symbol
        + "&apikey=" + APIKey.key.rawValue
        guard let url = URL(string: urlString) else { return }

        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .decode(type: Quote.self, decoder: JSONDecoder())
            .sink { _ in } receiveValue: { [weak self] quote in
                stock.price = NSDecimalNumber(string: quote.globalQuote.price)
                stock.change = NSDecimalNumber(string: quote.globalQuote.change)
                stock.changePercent = NSDecimalNumber(string: quote.globalQuote.changePercent)
                PersistenceController.shared.save()
                self?.subscription?.cancel()
            }
    }
}
