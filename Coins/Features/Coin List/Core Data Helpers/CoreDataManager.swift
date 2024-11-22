//
//  CoreDataManager.swift
//  Coins
//
//  Created by Arpit Dongre on 21/11/24.
//

import CoreData
import Foundation

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    func saveCoinsToCoreData(coins: [Coin]) {
        
        deleteAllCoins()
        
        for coin in coins {
            let coinEntity = CoinEntity(context: context)
            coinEntity.name = coin.name
            coinEntity.symbol = coin.symbol
            coinEntity.isNew = coin.isNew
            coinEntity.isActive = coin.isActive
            coinEntity.type = coin.type.rawValue

            do {
                try context.save()
            } catch {
                print("Error saving to Core Data: \(error)")
            }
        }
    }
    
    func fetchCoinsFromCoreData() -> [Coin]? {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        
        do {
            let coinEntities = try context.fetch(fetchRequest)
            return coinEntities.map {
                return Coin(
                    name: $0.name ?? "",
                    symbol: $0.symbol ?? "",
                    isNew: $0.isNew,
                    isActive: $0.isActive,
                    type: TypeEnum(rawValue: $0.type ?? "coin") ?? .coin
                )
            }
        } catch {
            print("Error fetching coins from Core Data: \(error)")
            return nil
        }
    }
    
    func deleteAllCoins() {
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        
        do {
            let coinsToDelete = try context.fetch(fetchRequest)
            for coin in coinsToDelete {
                context.delete(coin)
            }
            try context.save()
        } catch {
            print("Error deleting coins from Core Data: \(error)")
        }
    }
}
