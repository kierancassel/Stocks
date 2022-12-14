//
//  StockDetailView.swift
//  Stocks
//
//  Created by Kieran Cassel on 07/10/2022.
//

import SwiftUI

struct StockDetailView: View {
    var stock: Stock
    var changeColor: Color { stock.changePercent > 0 ? .green : .red }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = stock.logoURL {
                    AsyncImage(url: URL(string: url)) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                }
                VStack(alignment: .leading) {
                    Text("$" + (stock.symbol ?? ""))
                    Text("$" + String(format: "%.2f", stock.price))
                        .font(.title)
                    Text((String(format: "%.2f", stock.changePercent)) + "%")
                        .font(.footnote)
                        .background(RoundedRectangle(cornerRadius: 20).fill(changeColor).frame(width: 50, height: 20))
                }
            }
            Spacer()
        }
        .navigationTitle(stock.name ?? "")
        .navigationBarTitleDisplayMode(.large)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stock: CoreDataManager.previewStock)
        }
    }
}
