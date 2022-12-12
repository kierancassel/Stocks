//
//  StockDataService.swift
//  Stocks
//
//  Created by Kieran Cassel on 06/10/2022.
//

import Foundation
import Combine

protocol StockDataService {
    func queryStocks(searchTerm: String) -> AnyPublisher<Query, Error>
    func updateStock(symbol: String) -> AnyPublisher<Quote, Error>
}

enum StockDataServiceError: LocalizedError {
    case invalidURL
    case decodingError(String)
    case genericError(String)

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError:
            return "Error decoding response"
        case .genericError(let message):
            return message
        }
    }
}

class AlphaVantageService: StockDataService {
    func queryStocks(searchTerm: String) -> AnyPublisher<Query, Error> {
        guard let url = URL(string: AppConfig.apiURL + "?function=SYMBOL_SEARCH&keywords=" + searchTerm
                            + "&apikey=" + AppConfig.apiKey)
        else { return Fail(error: StockDataServiceError.invalidURL).eraseToAnyPublisher() }
        return NetworkManager.request(url: url)
            .decode(type: Query.self, decoder: JSONDecoder())
            .mapError { error -> StockDataServiceError in
                if let decodingError = error as? DecodingError {
                    return StockDataServiceError.decodingError((decodingError as NSError).debugDescription)
                }
                return StockDataServiceError.genericError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    func updateStock(symbol: String) -> AnyPublisher<Quote, Error> {
        guard let url = URL(string: AppConfig.apiURL + "?function=GLOBAL_QUOTE&symbol=" + symbol
                            + "&apikey=" + AppConfig.apiKey)
        else { return Fail(error: StockDataServiceError.invalidURL).eraseToAnyPublisher() }
        return NetworkManager.request(url: url)
            .decode(type: Quote.self, decoder: JSONDecoder())
            .mapError { error -> StockDataServiceError in
                if let decodingError = error as? DecodingError {
                    return StockDataServiceError.decodingError((decodingError as NSError).debugDescription)
                }
                return StockDataServiceError.genericError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
