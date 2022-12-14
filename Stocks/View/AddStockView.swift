//
//  AddStockView.swift
//  Stocks
//
//  Created by Kieran Cassel on 04/10/2022.
//

import SwiftUI

struct AddStockView: View {
    @EnvironmentObject private var viewModel: StockViewModel
    @State private var searchTerm: String = ""
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        VStack {
            VStack {
                TextField("Stock symbol", text: $searchTerm).textFieldStyle(.roundedBorder)
                Button("Search", action: search).buttonStyle(.borderedProminent)
            }.padding(20)
            List {
                if let symbols = viewModel.symbols {
                    ForEach(symbols) { symbol in
                        StockCell(symbol: symbol.symbol ?? "", name: symbol.name ?? "",
                                  add: { addPressed(symbol: $0, name: $1) })
                    }
                    if symbols.count == 0 {
                        Text("No results found")
                    }
                }
            }.listStyle(PlainListStyle())
        }
        .onAppear {
            viewModel.getSymbols()
        }
    }

    func search() {
        viewModel.searchSymbols(searchTerm: $searchTerm.wrappedValue)
    }
    func addPressed(symbol: String, name: String) {
        viewModel.addStock(symbol: symbol, name: name)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddStockView_Previews: PreviewProvider {
    static var previews: some View {
        AddStockView().environmentObject(StockViewModel(dataService: IEXService(networkManager: NetworkManager())))
    }
}
