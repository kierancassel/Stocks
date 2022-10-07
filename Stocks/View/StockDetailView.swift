//
//  StockDetailView.swift
//  Stocks
//
//  Created by Kieran Cassel on 07/10/2022.
//

import SwiftUI

struct StockDetailView: View {
    var stock: Stock
    var body: some View {
        VStack(alignment: .leading) {
            Text("$" + (stock.symbol ?? ""))
            Text("$" + String(format: "%.2f", Double(truncating: stock.price ?? 0)))
                .font(.title)
            Text((String(format: "%.2f", Double(truncating: stock.changePercent ?? 0))) + "%").font(.footnote)
                .background(RoundedRectangle(cornerRadius: 20).fill(changeColor).frame(width: 50, height: 20))
            Spacer()
        }
        .navigationTitle(stock.name ?? "Apple")
        .navigationBarTitleDisplayMode(.large)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var changeColor: Color { (Double(truncating: stock.changePercent ?? 0)) > 0 ? .green : .red }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stock: CoreDataService.previewStock)
        }
    }
}
