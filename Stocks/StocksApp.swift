//
//  StocksApp.swift
//  Stocks
//
//  Created by Kieran Cassel on 30/09/2022.
//

import SwiftUI

@main
struct StocksApp: App {
    let coreDataService = CoreDataService.shared

    var body: some Scene {
        WindowGroup {
            StockView()
                .environment(\.managedObjectContext, coreDataService.container.viewContext)
        }
    }
}
