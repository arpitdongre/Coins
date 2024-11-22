//
//  CoinListViewControllerTests.swift
//  CoinsTests
//
//  Created by Arpit Dongre on 22/11/24.
//

import XCTest
@testable import Coins

class CoinListViewControllerTests: XCTestCase {
    
    var viewController: CoinListViewController!
    var viewModel: CoinListViewModel!
    var mockAPIClient: MockCoinAPIClient!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUpWithError() throws {
        super.setUp()
        
        
        viewController = CoinListViewController()
        mockAPIClient = MockCoinAPIClient()
        mockCoreDataManager = MockCoreDataManager()
        
        viewModel = CoinListViewModel(coinApiClient: mockAPIClient, coreDataManager: mockCoreDataManager)
        viewController.viewModel = viewModel
        
        _ = viewController.view
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        viewModel = nil
        mockAPIClient = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    // MARK: - Test Error Handling
    func testShowErrorViewWhen_APIFails() async {
        let expectation = self.expectation(description: "Error view closure is triggered")
        
        viewController = await CoinListViewController()
        mockAPIClient = MockCoinAPIClient()
        mockCoreDataManager = MockCoreDataManager()
        
        viewModel = CoinListViewModel(coinApiClient: mockAPIClient, coreDataManager: mockCoreDataManager)
        viewController.viewModel = viewModel
        
        viewModel.showErrorViewClosure = {
            expectation.fulfill()
        }
        
        // Simulate the failure to fetch coins
        viewModel.isConnectedToInternet = true
        mockAPIClient.shouldFail = true
        
        Task {
             await viewController.viewModel.loadCoins()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    // MARK: - Test Error Handling
    func testShowLoadingView_loadingState() async {
        let expectation = self.expectation(description: "Loading view closure is triggered")
        
        viewController = await CoinListViewController()
        mockAPIClient = MockCoinAPIClient()
        mockCoreDataManager = MockCoreDataManager()
        
        viewModel = CoinListViewModel(coinApiClient: mockAPIClient, coreDataManager: mockCoreDataManager)
        viewController.viewModel = viewModel
        
        viewModel.showLoadingIndicatorClosure = {
            expectation.fulfill()
        }
        
        // Simulate the failure to fetch coins
        viewModel.isConnectedToInternet = true
        mockAPIClient.shouldFail = true
        
        Task {
             await viewController.viewModel.loadCoins()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    
    // MARK: Test Refresh Control
    func testRefreshDataTriggered() {
        viewController.refreshData()
        
        // Verify that refresh control is ended
        XCTAssertTrue(viewController.refreshControl.isRefreshing == false)
    }
}
