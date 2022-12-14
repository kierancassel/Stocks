//
//  IEXService.swift
//  Stocks
//
//  Created by Kieran Cassel on 13/12/2022.
//

import Foundation
import Combine

class IEXService: StockDataService {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func getSymbols() -> AnyPublisher<Symbols, Error> {
        guard let url = URL(string: AppConfig.apiURL + "/ref-data/symbols" + "?token=" + AppConfig.apiKey)
        else { return Fail(error: StockDataServiceError.invalidURL).eraseToAnyPublisher() }
        return networkManager.request(url: url)
            .decode(type: Symbols.self, decoder: JSONDecoder())
            .mapError { error -> StockDataServiceError in
                if let decodingError = error as? DecodingError {
                    return StockDataServiceError.decodingError((decodingError as NSError).debugDescription)
                }
                return StockDataServiceError.genericError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    func getQuote(symbol: String) -> AnyPublisher<Quote, Error> {
        guard let url = URL(string: AppConfig.apiURL + "/stock/" + symbol
                            + "/quote" + "?token=" + AppConfig.apiKey)
        else { return Fail(error: StockDataServiceError.invalidURL).eraseToAnyPublisher() }
        return networkManager.request(url: url)
            .decode(type: Quote.self, decoder: JSONDecoder())
            .mapError { error -> StockDataServiceError in
                if let decodingError = error as? DecodingError {
                    return StockDataServiceError.decodingError((decodingError as NSError).debugDescription)
                }
                return StockDataServiceError.genericError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    func getLogo(symbol: String) -> AnyPublisher<Logo, Error> {
        guard let url = URL(string: AppConfig.apiURL + "/stock/" + symbol
                            + "/logo" + "?token=" + AppConfig.apiKey)
        else { return Fail(error: StockDataServiceError.invalidURL).eraseToAnyPublisher() }
        return networkManager.request(url: url)
            .decode(type: Logo.self, decoder: JSONDecoder())
            .mapError { error -> StockDataServiceError in
                if let decodingError = error as? DecodingError {
                    return StockDataServiceError.decodingError((decodingError as NSError).debugDescription)
                }
                return StockDataServiceError.genericError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
