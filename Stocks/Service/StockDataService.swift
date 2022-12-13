//
//  StockDataService.swift
//  Stocks
//
//  Created by Kieran Cassel on 06/10/2022.
//

import Foundation
import Combine

protocol StockDataService {
    func getSymbols() -> AnyPublisher<Symbols, Error>
    func getQuote(symbol: String) -> AnyPublisher<Quote, Error>
    func getLogo(symbol: String) -> AnyPublisher<Logo, Error>
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
