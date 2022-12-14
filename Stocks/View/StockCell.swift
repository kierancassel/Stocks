//
//  StockCell.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import SwiftUI

struct StockCell: View {
    var symbol, name: String
    var logoURL: String?
    var price, change, changePercent: Double?
    var add: ((String, String) -> Void)?
    var changeColor: Color { changePercent ?? 0 > 0 ? .green : .red }

    var body: some View {
        HStack {
            if let logoURL {
                AsyncImage(url: URL(string: logoURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Text(symbol).fontWeight(.bold)
                Text(name).font(.footnote).foregroundColor(Color.gray)
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            Spacer()
            if let add {
                Button(action: {
                    add(symbol, name)

                }, label: {
                    Image(systemName: "plus.circle")
                })
            } else {
                VStack(alignment: .trailing) {
                    if let price, let changePercent {
                        Text(String(format: "%.2f", price)).fontWeight(.bold)
                        Text((String(format: "%.2f", changePercent)) + "%").font(.footnote).background(
                            RoundedRectangle(cornerRadius: 20).fill(changeColor).frame(width: 50, height: 17))
                    }
                }
            }
        }
    }

    struct StockCell_Previews: PreviewProvider {
        static var previews: some View {
            let logoURL = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png"
            Group {
                StockCell(symbol: "AAPL", name: "Apple Inc.", logoURL: logoURL,
                          price: 140, change: 1.99, changePercent: 1.99)
                StockCell(symbol: "AAPL", name: "Apple Inc.", logoURL: logoURL,
                          price: 140, change: 1.99, changePercent: -1.99)
                StockCell(symbol: "AAPL", name: "Apple Inc.", add: { _, _  in })
            }
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
