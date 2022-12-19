//
//  StocksApp.swift
//  Stocks
//
//  Created by Kieran Cassel on 30/09/2022.
//

import SwiftUI

@main
struct StocksApp: App {
    var body: some Scene {
        WindowGroup {
            StockView(viewModel: StockViewModel(
                dataService: IEXService(
                    networkManager: NetworkManager(),
                    stockService: StockService()
                )))
        }
    }
}
