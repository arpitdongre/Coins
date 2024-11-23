//
//  Coin.swift
//  Coins
//
//  Created by Arpit Dongre on 20/11/24.
//

import Foundation

struct Coin {
    let name: String
    let symbol: String
    let isNew: Bool
    let isActive: Bool
    let type: TypeEnum
    
    var imageName: String {
        get {
            if type == .coin {
                if isActive {
                    return "active-coin"
                } else {
                    return "inactive-coin"
                }
            } else {
                return "token"
            }
        }
    }
}

extension Coin {
    
    init(from apiCoin: CoinAPIResponse) {
        self.name = apiCoin.name
        self.symbol = apiCoin.symbol
        self.isNew = apiCoin.isNew
        self.isActive = apiCoin.isActive
        self.type = apiCoin.type
    }
}
