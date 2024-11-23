//
//  MockCoreDataManager.swift
//  CoinsTests
//
//  Created by Arpit Dongre on 22/11/24.
//

import CoreData
import Foundation
@testable import Coins

class MockCoreDataManager: CoreDataManager {
    
    var coins: [Coin] = []
    
    override func saveCoinsToCoreData(coins: [Coin]) {
        self.coins = coins
    }
    
    override func fetchCoinsFromCoreData() -> [Coin]? {
        return coins
    }
    
    override func deleteAllCoins() {
        coins.removeAll()
    }
}
