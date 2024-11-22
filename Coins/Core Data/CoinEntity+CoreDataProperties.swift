//
//  CoinEntity+CoreDataProperties.swift
//  Coins
//
//  Created by Arpit Dongre on 21/11/24.
//
//

import Foundation
import CoreData


extension CoinEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinEntity> {
        return NSFetchRequest<CoinEntity>(entityName: "CoinEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var isNew: Bool
    @NSManaged public var isActive: Bool
    @NSManaged public var type: String?

}

extension CoinEntity : Identifiable {

}
