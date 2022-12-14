//
//  MockNetworkManager.swift
//  StocksTests
//
//  Created by Kieran Cassel on 14/12/2022.
//

import Foundation
import Combine
@testable import Stocks

class MockNetworkManager: NetworkManagerProtocol {
    func request(url: URL) -> AnyPublisher<Data, Error> {
        var resource: String
        if url.absoluteString.contains("/ref-data/symbols") { resource = "Symbols" } else
        if url.absoluteString.contains("/quote") { resource = "Quote" } else { resource = "Logo" }

        let url = Bundle(for: MockNetworkManager.self).url(forResource: resource, withExtension: "json")!
        do {
            let data = try Data(contentsOf: url)
            return Result.Publisher(data).eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
