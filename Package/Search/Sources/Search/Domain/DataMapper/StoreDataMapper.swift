//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/21.
//

import Foundation

import Entitys
import DomainEntity

public protocol StoreDataMapperImpl {
    func toDataModel(domainModel: StoreEntity) -> [StoreDomainEntity]
}

public struct StoreDataMapper: StoreDataMapperImpl {
    public init() {}
    public func toDataModel(domainModel: StoreEntity) -> [StoreDomainEntity] {
        return domainModel.items.map { item -> StoreDomainEntity in
            return StoreDomainEntity(item: item)
        }
    }
}
