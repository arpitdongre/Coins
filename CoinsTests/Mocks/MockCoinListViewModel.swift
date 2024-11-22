//
//  MockCoinListViewModel.swift
//  CoinsTests
//
//  Created by Arpit Dongre on 22/11/24.
//

import XCTest
@testable import Coins

class MockCoinListViewModel: CoinListViewModel {
    var isLoadCoinsCalled = false
    var isApplyFiltersCalled = false
}
