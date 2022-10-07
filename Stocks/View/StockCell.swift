//
//  StockCell.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import SwiftUI

struct StockCell: View {
    var symbol, name: String
    var price, change, changePercent: Double?
    var add: ((String, String) -> Void)?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(symbol).fontWeight(.bold)
                Text(name).font(.footnote).foregroundColor(Color.gray)
            }
            Spacer()
            if add == nil {
                VStack(alignment: .trailing) {
                    if let price, let changePercent {
                        Text(String(format: "%.2f", price)).fontWeight(.bold)
                        Text((String(format: "%.2f", changePercent)) + "%").font(.footnote).background(
                            RoundedRectangle(cornerRadius: 20).fill(changeColor).frame(width: 50, height: 17))
                    }
                }
            } else {
                if let add {
                    Button(action: { add(symbol, name) }) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }
    var changeColor: Color { changePercent ?? 0 > 0 ? .green : .red }
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            StockCell(symbol: "AAPL", name: "Apple Inc.", price: 140, change: 1.99, changePercent: 1.99)
            StockCell(symbol: "AAPL", name: "Apple Inc.", price: 140, change: 1.99, changePercent: -1.99)
            StockCell(symbol: "AAPL", name: "Apple Inc.", add: { _, _  in })
        }
    }
}
