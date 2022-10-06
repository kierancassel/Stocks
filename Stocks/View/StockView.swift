//
//  StockView.swift
//  Stocks
//
//  Created by Kieran Cassel on 30/09/2022.
//

import SwiftUI

struct StockView: View {
    @ObservedObject var stockViewModel = StockViewModel(networkManager: PublicNetworkManager())
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
                        StockCell(symbol: stock.symbol ?? "", name: stock.name ?? "",
                                  price: Double(truncating: stock.price ?? 0),
                                  change: Double(truncating: stock.change ?? 0),
                                  changePercent: Double(truncating: stock.changePercent ?? 0))
                    }.onDelete(perform: delete)
                    if stockViewModel.stocks.count == 0 {
                        Text("Watchlist empty")
                    }
                }
                NavigationLink(destination: AddStockView(stockViewModel: stockViewModel)) {
                    Text("+Add")
                }
            }.onAppear {
                stockViewModel.getStocks()
                //stockViewModel.updateStocks()
            }
        }
    }
    func date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }
    func delete(offsets: IndexSet) {
        stockViewModel.deleteStocks(offsets: offsets)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StockView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
