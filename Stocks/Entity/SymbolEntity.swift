//
//  SymbolEntity.swift
//  Stocks
//
//  Created by Kieran Cassel on 16/12/2022.
//

import Foundation

struct SymbolEntity: Identifiable {
    var id = UUID()
    let name: String
    let symbol: String
}
