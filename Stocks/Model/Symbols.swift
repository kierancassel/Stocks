//
//  Symbol.swift
//  Stocks
//
//  Created by Kieran Cassel on 13/12/2022.
//

import Foundation

struct SymbolElement: Codable {
    let symbol: String
    let name, date: String
    let isEnabled: Bool
}

typealias Symbols = [SymbolElement]
