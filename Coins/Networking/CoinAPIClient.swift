//
//  CoinAPIClient.swift
//  Coins
//
//  Created by Arpit Dongre on 20/11/24.
//

import Foundation

class CoinAPIClient {
    
    static let shared = CoinAPIClient()
    init() {}
    
    func fetchCoins() async throws -> [CoinAPIResponse] {
        
        let urlString = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        
        let session = URLSession(configuration: configuration)

        do {
            let (data, _) = try await session.data(from: url)
            
            let coins = try JSONDecoder().decode([CoinAPIResponse].self, from: data)
            return coins
        } catch {
            throw error
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
