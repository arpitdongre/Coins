//
//  CoinListViewModelTests.swift
//  CoinsTests
//
//  Created by Arpit Dongre on 22/11/24.
//

import XCTest
@testable import Coins

class CoinListViewModelTests: XCTestCase {
    
    var viewModel: CoinListViewModel!
    var mockAPIClient: MockCoinAPIClient!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUpWithError() throws {
        super.setUp()
        
        mockAPIClient = MockCoinAPIClient()
        mockCoreDataManager = MockCoreDataManager()
        
        viewModel = CoinListViewModel(coinApiClient: mockAPIClient, coreDataManager: mockCoreDataManager)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockAPIClient = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    // MARK: Test loadCoins from API
  
    func testLoadCoins_fromAPI_success() async {
      
        let mockCoins = [
                CoinAPIResponse(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: .coin),
                CoinAPIResponse(name: "Ethereum", symbol: "ETH", isNew: false, isActive: true, type: .coin)
        ]
        
        // Make the mock API client to return mock data
        mockAPIClient.coins = mockCoins
        
        await viewModel.loadCoins()
        
        XCTAssertEqual(viewModel.numberOfRows(), 2)
        XCTAssertEqual(viewModel.coinAt(index: 0).name, "Bitcoin")
        XCTAssertEqual(viewModel.coinAt(index: 1).name, "Ethereum")
    }
    
    // MARK: Test loadCoins from CoreData (when offline)
    func testLoadCoins_fromCoreData_whenOffline() async {
        // Given
        let offlineCoins = [
            Coin(name: "OfflineCoin", symbol: "OC", isNew: false, isActive: true, type: .coin)
        ]
        
        mockCoreDataManager.coins = offlineCoins
        
        // Simulate the offline mode
        viewModel.isConnectedToInternet = false
        
        await viewModel.loadCoins()
                
        XCTAssertEqual(viewModel.numberOfRows(), 1)
        XCTAssertEqual(viewModel.coinAt(index: 0).name, "OfflineCoin")
    }
    
    // MARK: Test applying filters
    func testApplyFilters_filtersActiveCoins() {

        let coins = [
            Coin(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: .coin),
            Coin(name: "Ethereum", symbol: "ETH", isNew: false, isActive: false, type: .coin),
            Coin(name: "Tether", symbol: "USDT", isNew: true, isActive: true, type: .token)
        ]
        
        viewModel.coins = coins
        viewModel.filteredCoins = coins

        viewModel.applyFilters([.active])
        
        XCTAssertEqual(viewModel.numberOfRows(), 2)
        XCTAssertEqual(viewModel.coinAt(index: 0).name, "Bitcoin")
        XCTAssertEqual(viewModel.coinAt(index: 1).name, "Tether")
    }
}
