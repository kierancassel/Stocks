//
//  Stock.swift
//  Stocks
//
//  Created by Kieran Cassel on 02/10/2022.
//

import Foundation

struct Stock: Identifiable {
    var id = UUID()
    var symbol: String
    var name: String
    var price: Decimal
    var change: Decimal
}
