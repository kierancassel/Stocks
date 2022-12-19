//
//  AddStockView.swift
//  Stocks
//
//  Created by Kieran Cassel on 04/10/2022.
//

import SwiftUI

struct AddStockView: View {
    @StateObject var viewModel: AddStockViewModel
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            VStack {
                TextField("Search for stock", text: $viewModel.searchTerm).textFieldStyle(.roundedBorder)
            }.padding(20)
            List {
                if let symbols = viewModel.getFilteredSymbols() {
                    ForEach(symbols) { symbol in
                        StockCell(symbol: symbol.symbol, name: symbol.name,
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
    func addPressed(symbol: String, name: String) {
        viewModel.addStock(symbol: symbol, name: name)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddStockView_Previews: PreviewProvider {
    static var previews: some View {
        AddStockView(viewModel: AddStockViewModel(
            dataService: IEXService(
                networkManager: NetworkManager(),
                symbolService: SymbolService()
            )))
    }
}
