//
//  AddStockView.swift
//  Stocks
//
//  Created by Kieran Cassel on 04/10/2022.
//

import SwiftUI

struct AddStockView: View {
    @ObservedObject var stockViewModel: StockViewModel
    @State private var searchTerm: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            VStack {
                TextField("Stock symbol", text: $searchTerm)
                Button("Search", action: search)
            }.padding(10)
            List {
                if let matches = stockViewModel.query?.bestMatches {
                    ForEach(matches) { match in
                        StockCell(symbol: match.symbol, name: match.name,
                                  add: { addPressed(symbol: $0, name: $1) })
                    }
                    if matches.count == 0 {
                        Text("No results found")
                    }
                }
            }
        }
    }
    func search() {
        Task {
            await stockViewModel.queryStocks(searchTerm: $searchTerm.wrappedValue)
        }
    }
    func addPressed(symbol: String, name: String) {
        Task {
            await stockViewModel.addStock(symbol: symbol, name: name)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddStockView_Previews: PreviewProvider {
    static var previews: some View {
        AddStockView(stockViewModel: StockViewModel(networkManager: PublicNetworkManager()))
    }
}
