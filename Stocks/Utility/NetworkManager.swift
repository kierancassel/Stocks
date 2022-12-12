//
//  NetworkManager.swift
//  Stocks
//
//  Created by Kieran Cassel on 12/12/2022.
//

import Foundation
import Combine

class NetworkManager {
    static func request(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .tryMap({ try handleResponse(output: $0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    static func handleResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        if let response = output.response as? HTTPURLResponse {
            guard (200..<300) ~= response.statusCode else {
                throw NetworkManagerError.invalidServerResponse(response.statusCode)
            }
        }
        return output.data
    }
}

enum NetworkManagerError: LocalizedError {
    case invalidServerResponse(Int)

    var errorDescription: String {
        switch self {
        case .invalidServerResponse(let responseCode):
            return "Invalid response code: \(responseCode)"
        }
    }
}
