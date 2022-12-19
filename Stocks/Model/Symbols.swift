//
//  Symbol.swift
//  Stocks
//
//  Created by Kieran Cassel on 13/12/2022.
//

import Foundation

struct SymbolElement: Decodable {
    let symbol: String
    let name, date: String
    let isEnabled: Bool
}

extension SymbolElement {
    func symbolEntityMapper() -> SymbolEntity {
        return SymbolEntity(name: name, symbol: symbol)
    }
}

typealias Symbols = [SymbolElement]
