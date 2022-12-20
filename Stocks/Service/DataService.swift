//
//  DataService.swift
//  Stocks
//
//  Created by Kieran Cassel on 06/10/2022.
//

import Foundation
import Combine

protocol DataService { }

protocol StockDataService: DataService {
    func getQuote(symbol: String) -> AnyPublisher<Quote, Error>
    func updateStocks()
    func deleteStock(stock: Stock)
    func getStocks() -> [Stock]
    func moveStock()
}

protocol SymbolDataService: DataService {
    func getSymbols() -> AnyPublisher<[SymbolEntity], Error>
    func getLogo(symbol: String) -> AnyPublisher<Logo, Error>
    func addStock(symbol: String, name: String, logoURL: String)
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
