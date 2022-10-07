//
//  StockView.swift
//  Stocks
//
//  Created by Kieran Cassel on 30/09/2022.
//

import SwiftUI

struct StockView: View {
    @ObservedObject var viewModel = StockViewModel()
    @State var isEditing = false
    var body: some View {
        VStack {
            VStack {
                Text("Stocks").font(.title2).fontWeight(.heavy).frame(maxWidth: .infinity, alignment: .leading)
                Text(date())
                    .font(.title2).fontWeight(.heavy).foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            NavigationView {
                VStack {
                    List {
                        ForEach(viewModel.watchlist) { stock in
                            NavigationLink(destination: StockDetailView(stock: stock)) {
                                StockCell(symbol: stock.symbol ?? "", name: stock.name ?? "",
                                          price: Double(truncating: stock.price ?? 0),
                                          change: Double(truncating: stock.change ?? 0),
                                          changePercent: Double(truncating: stock.changePercent ?? 0))
                            }
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
//                        .onTapGesture(perform: tap)
                        if viewModel.watchlist.count == 0 {
                            Text("Watchlist empty")
                        }
                    }
                    .navigationBarTitle(Text("Watchlist"), displayMode: .inline)
                    .listStyle(PlainListStyle())
                    .environment(\.editMode,
                                  .constant(self.isEditing ? EditMode.active : EditMode.inactive))
                    .animation(.spring())
                    .toolbar { toolbar }
                }
                .onAppear {
                    viewModel.updateStocks()
                }
            }
        }
    }

    var toolbar: some View {
        HStack {
            Button(action: { isEditing.toggle() }) {
                if self.isEditing {
                    Text("Done")
                } else {
                    Image(systemName: "pencil.circle.fill")
                }
            }
            NavigationLink(destination: AddStockView(viewModel: AddStockViewModel())) {
                Image(systemName: "plus.circle.fill")
            }
        }
    }

    func date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: Date())
    }
    func move(source: IndexSet, destination: Int) {
        viewModel.moveStock(source: source, destination: destination)
    }
    func delete(offsets: IndexSet) {
        viewModel.deleteStocks(offsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StockView().environment(\.managedObjectContext, CoreDataService.preview.container.viewContext)
    }
}
