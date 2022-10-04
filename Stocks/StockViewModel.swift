//
//  StockViewModel.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import Foundation

class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    func getStocks() {
        stocks = [Stock(symbol: "AAPL", name: "Apple Inc.", price: 140.00, change: 1.99),
                       Stock(symbol: "GOOG", name: "Alphabet Inc.", price: 96.00, change: -1.99)]
    }
}
