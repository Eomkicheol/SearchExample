//
//  SearchRepository.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Networking
import RxSwift
import Entitys
import Apis
import DomainEntity

public struct SearchRepository: SearchRepositoryProtocol  {
    
    public var searchKey: String {
        return "Search"
    }
    
    private let network: NetworkType
    private let dataMapper: StoreDataMapper
    private let userDefault: UserDefaultProtocol
    
    public init(network: NetworkType,
                dataMapper: StoreDataMapper,
                userDefault: UserDefaultProtocol) {
        self.network = network
        self.dataMapper = dataMapper
        self.userDefault = userDefault
    }
    
    public func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<[StoreDomainEntity]> {
        return self.network.request(SearchApi.search(keyword: keyword, limit: limit))
            .map {  item -> [StoreDomainEntity] in
                return self.dataMapper.toDataModel(domainModel: item)
            }
            .asObservable()
    }
    
    public func toDataModel(domainModel: StoreEntity) -> [StoreDomainEntity] {
        return self.dataMapper.toDataModel(domainModel: domainModel)
    }
    
    
    public func fetchSearchKeywords() -> [String] {
        self.userDefault.getString(self.searchKey)
    }
    
    public func saveSearchKeywords(value: [String]) {
        self.userDefault.setString(self.searchKey, value: value)
    }
}
