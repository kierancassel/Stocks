//
//  AddStockView.swift
//  Stocks
//
//  Created by Kieran Cassel on 04/10/2022.
//

import SwiftUI

struct AddStockView: View {
    @ObservedObject var viewModel: AddStockViewModel
    @State private var searchTerm: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            VStack {
                TextField("Stock symbol", text: $searchTerm).textFieldStyle(.roundedBorder)
                Button("Search", action: search).buttonStyle(.borderedProminent)
            }.padding(20)
            List {
                if let matches = viewModel.query?.bestMatches {
                    ForEach(matches) { match in
                        StockCell(symbol: match.symbol, name: match.name,
                                  add: { addPressed(symbol: $0, name: $1) })
                    }
                    if matches.count == 0 {
                        Text("No results found")
                    }
                }
            }.listStyle(PlainListStyle())
        }.animation(.spring())
    }

    func search() {
        viewModel.queryStocks(searchTerm: $searchTerm.wrappedValue)
    }
    func addPressed(symbol: String, name: String) {
        viewModel.addStock(symbol: symbol, name: name)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddStockView_Previews: PreviewProvider {
    static var previews: some View {
        AddStockView(viewModel: AddStockViewModel())
    }
}
