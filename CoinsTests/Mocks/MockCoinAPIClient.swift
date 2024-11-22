//
//  MockCoinAPIClient.swift
//  CoinsTests
//
//  Created by Arpit Dongre on 22/11/24.
//

import Foundation
@testable import Coins

class MockCoinAPIClient: CoinAPIClient {
    var coins: [CoinAPIResponse] = []
    var shouldFail = false
    
    override func fetchCoins() async throws -> [CoinAPIResponse] {
        if shouldFail {
            throw NetworkError.noData
        }
        return coins
    }
}
