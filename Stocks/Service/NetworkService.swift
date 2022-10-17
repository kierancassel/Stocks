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
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                        response.statusCode >= 200 &&
                        response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: Query.self, decoder: JSONDecoder())
            .sink {
                if case .failure(let error) = $0 {
                    print(error)
                }
            } receiveValue: { [weak self] query in
                self?.query = query
                self?.subscription?.cancel()
            }
    }

    func updateStock(stock: Stock, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let symbol = stock.symbol else { return }
        let urlString: String = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + symbol
        + "&apikey=" + APIKey.key.rawValue
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
