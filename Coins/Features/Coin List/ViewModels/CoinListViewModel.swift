//
//  CoinListViewModel.swift
//  Coins
//
//  Created by Arpit Dongre on 20/11/24.
//

import Foundation

class CoinListViewModel {
    
    var coins: [Coin] = []
    var filteredCoins: [Coin] = []
    var isConnectedToInternet: Bool = true
    
    var reloadTableViewClosure: (() -> Void)?
    var updateOfflineLabelClosure: ((Bool) -> Void)?
    
    var showLoadingIndicatorClosure: (() -> Void)?
    var hideLoadingIndicatorClosure: (() -> Void)?
    var showErrorViewClosure: (() -> Void)?
    var hideErrorViewClosure: (() -> Void)?
    
    var coinApiClient: CoinAPIClient
    var coreDataManager: CoreDataManager

    init(coinApiClient: CoinAPIClient = CoinAPIClient.shared, coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coinApiClient = coinApiClient
        self.coreDataManager = coreDataManager
        
        _ = NetworkManager.shared
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusChanged(_:)), name: .networkStatusChanged, object: nil)
    }
    
    @objc func handleNetworkStatusChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let isConnected = userInfo["isConnected"] as? Bool else { return }
        
        self.isConnectedToInternet = isConnected
        
        // Notify the ViewController to update the UI
        updateOfflineLabelClosure?(isConnected)
    }
    
    @MainActor
    func loadCoins() async {
        self.hideErrorViewClosure?()

        showLoadingIndicatorClosure?()
        if isConnectedToInternet {
            await self.fetchCoins()
        } else {
            hideLoadingIndicatorClosure?()
            let offlineCoins = coreDataManager.fetchCoinsFromCoreData()
            self.coins = offlineCoins ?? []
            self.filteredCoins = self.coins
            self.reloadTableViewClosure?()
        }
    }
    
    @MainActor
    func fetchCoins() async {
        do {
            let apiCoins = try await coinApiClient.fetchCoins()
            self.coins = apiCoins.map { Coin.init(from: $0)}
            CoreDataManager.shared.saveCoinsToCoreData(coins: coins)
            self.filteredCoins = self.coins
            
            reloadTableViewClosure?()
            self.hideLoadingIndicatorClosure?()
        } catch {
            self.showErrorViewClosure?()
            self.hideLoadingIndicatorClosure?()
        }
    }
    
    func numberOfRows() -> Int {
        return filteredCoins.count
    }
    
    func coinAt(index: Int) -> Coin {
        return filteredCoins[index]
    }
    
    func applyFilters(_ selectedFilters: [CoinFilter]) {
        
        if selectedFilters.isEmpty {
            self.filteredCoins = coins
        } else {
            self.filteredCoins = coins.filter {
                coin in
                
                return selectedFilters.contains { filter in
                    
                    switch filter {
                        
                    case .active:
                        return coin.isActive
                    case .inactive:
                        return !coin.isActive
                    case .new:
                        return coin.isNew
                    case .onlyCoins:
                        return coin.type == .coin
                    case .onlyTokens:
                        return coin.type == .token
                    }
                }
            }
        }
        
        reloadTableViewClosure?()
    }
}
