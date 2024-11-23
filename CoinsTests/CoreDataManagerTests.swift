//
//  CoreDataManagerTests.swift
//  CoinsTests
//
//  Created by Arpit Dongre on 22/11/24.
//

import XCTest
import CoreData

@testable import Coins

class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.init()
    }
    
    override func tearDown() {
        super.tearDown()
        
        coreDataManager.deleteAllCoins()
        coreDataManager = nil
    }
    
    // MARK: - Tests
    
    func testSaveCoinsToCoreData() {
        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC", isNew: true, isActive: true, type: .coin),
            Coin(name: "Ethereum", symbol: "ETH", isNew: true, isActive: true, type: .coin)
        ]
        
        coreDataManager.saveCoinsToCoreData(coins: coins)
        
        let fetchedCoins = coreDataManager.fetchCoinsFromCoreData()
        XCTAssertEqual(fetchedCoins?.count, 2)
        
        let firstCoin = fetchedCoins?.first
        XCTAssertEqual(firstCoin?.name, "Bitcoin")
        XCTAssertEqual(firstCoin?.symbol, "BTC")
    }
    
    func testFetchCoinsFromCoreData() {
        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC", isNew: true, isActive: true, type: .coin)
        ]
        
        coreDataManager.saveCoinsToCoreData(coins: coins)
        
        let fetchedCoins = coreDataManager.fetchCoinsFromCoreData()
        
        // Then
        XCTAssertEqual(fetchedCoins?.count, 1)
        XCTAssertEqual(fetchedCoins?.first?.name, "Bitcoin")
        XCTAssertEqual(fetchedCoins?.first?.symbol, "BTC")
    }
    
    func testDeleteAllCoins() {
        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC", isNew: true, isActive: true, type: .coin),
            Coin(name: "Ethereum", symbol: "ETH", isNew: true, isActive: true, type: .coin)
        ]
        
        coreDataManager.saveCoinsToCoreData(coins: coins)
        
        coreDataManager.deleteAllCoins()
        
        let fetchedCoins = coreDataManager.fetchCoinsFromCoreData()
        XCTAssertEqual(fetchedCoins?.count, 0)
    }
}
