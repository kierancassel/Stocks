//
//  StockCell.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import SwiftUI

struct StockCell: View {
    var stock: Stock
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol).fontWeight(.bold)
                Text(stock.name).font(.footnote).foregroundColor(Color.gray)
            }
            Spacer()
            VStack {
                Text(String(describing: stock.price)).fontWeight(.bold)
                Text(String(describing: stock.change)).font(.footnote).background(
                    RoundedRectangle(cornerRadius: 20).fill(changeColor).frame(width: 40, height: 15))
            }
        }
    }
    var changeColor: Color {
        return stock.change > 0 ? .green : .red
    }
}

struct StockCell_Previews: PreviewProvider {
    static var previews: some View {
        let apple = Stock(symbol: "AAPL", name: "Apple Inc.", price: 140.00, change: 1.99)
        let google = Stock(symbol: "GOOG", name: "Alphabet Inc.", price: 96.00, change: -1.99)
        List {
            StockCell(stock: apple)
            StockCell(stock: google)
        }
    }
}
