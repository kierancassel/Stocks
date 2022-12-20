//
//  IEXService.swift
//  Stocks
//
//  Created by Kieran Cassel on 13/12/2022.
//

import Foundation
import Combine

class IEXService {
    private let networkManager: Networkable
    private var stockService: StockServicable?
    private var symbolService: SymbolServicable?

    init(networkManager: Networkable, stockService: StockServicable) {
        self.networkManager = networkManager
        self.stockService = stockService
    }
    init(networkManager: Networkable, symbolService: SymbolServicable) {
        self.networkManager = networkManager
        self.symbolService = symbolService
    }
}

extension IEXService: StockDataService {
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
    func updateStocks() {
        stockService?.updateStocks()
    }
    func deleteStock(stock: Stock) {
        stockService?.deleteStock(stock: stock)
    }
    func getStocks() -> [Stock] {
        stockService?.getStocks() ?? []
    }
    func moveStock() {
        stockService?.moveStock()
    }
}

extension IEXService: SymbolDataService {
    func getSymbols() -> AnyPublisher<[SymbolEntity], Error> {
        let symbols = symbolService?.getSymbols() ?? []
        guard symbols.count == 0 else {
            return Just(symbols)
                .map { symbols in
                    symbols.map {
                        $0.symbolEntityMapper()
                    }
                }
                .mapError { error -> StockDataServiceError  in
                    StockDataServiceError.genericError(error.localizedDescription)
                }.eraseToAnyPublisher()
        }
        guard let url = URL(string: AppConfig.apiURL + "/ref-data/symbols" + "?token=" + AppConfig.apiKey)
        else { return Fail(error: StockDataServiceError.invalidURL).eraseToAnyPublisher() }
        return networkManager.request(url: url)
            .decode(type: Symbols.self, decoder: JSONDecoder()).map { symbolElements in
                self.symbolService?.addSymbols(symbols: symbolElements)
                return symbolElements.map {
                    $0.symbolEntityMapper()
                }
            }
            .mapError { error -> StockDataServiceError in
                if let decodingError = error as? DecodingError {
                    return StockDataServiceError.decodingError((decodingError as NSError).debugDescription)
                }
                return StockDataServiceError.genericError(error.localizedDescription)
            }.eraseToAnyPublisher()
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
    func addStock(symbol: String, name: String, logoURL: String) {
        symbolService?.addStock(symbol: symbol, name: name, logoURL: logoURL)
    }
}
