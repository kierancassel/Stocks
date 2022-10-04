//
//  StockView.swift
//  Stocks
//
//  Created by Kieran Cassel on 30/09/2022.
//

import SwiftUI

struct StockView: View {
    @ObservedObject var stockViewModel = StockViewModel()
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        Text("Stocks").font(.title2).fontWeight(.heavy).frame(maxWidth: .infinity, alignment: .leading)
                        Text(date())
                            .font(.title2).fontWeight(.heavy).foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                }
                List {
                    ForEach(stockViewModel.stocks) { stock in
                        StockCell(stock: stock)
                    }.onDelete(perform: delete)
                }
                NavigationLink(destination: AddStockView()) {
                    Text("+Add")
                }
            }.onAppear {
                stockViewModel.getStocks()
            }
        }
    }
    func date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }
    func delete(offsets: IndexSet) {
        stockViewModel.stocks.remove(atOffsets: offsets)
        print(stockViewModel.stocks)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StockView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
