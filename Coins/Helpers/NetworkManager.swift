//
//  NetworkManager.swift
//  Coins
//
//  Created by Arpit Dongre on 21/11/24.
//

import Network
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private var isConnected: Bool = false
    
    private init() {

        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected = true
                NotificationCenter.default.post(name: .networkStatusChanged, object: nil, userInfo: ["isConnected": true])
            } else {
                self?.isConnected = false
                NotificationCenter.default.post(name: .networkStatusChanged, object: nil, userInfo: ["isConnected": false])
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func getNetworkStatus() -> Bool {
        return isConnected
    }
    
    func isConnectedToInternet(completion: @escaping (Bool) -> Void) {
         let monitor = NWPathMonitor()
         let queue = DispatchQueue(label: "NetworkMonitor")
         
         monitor.pathUpdateHandler = { path in
             if path.status == .satisfied {
                 completion(true)
             } else {
                 completion(false)
             }
         }
         
         monitor.start(queue: queue)
     }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
