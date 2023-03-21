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


public struct SearchRepository: SearchRepositoryImpl  {
    
    private let network: NetworkType
    private let dataMapper: StoreDataMapper
    private let userDefault: UserdefaultImpl
    
    public init(network: NetworkType,
                dataMapper: StoreDataMapper,
                userDefault: UserdefaultImpl) {
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
    
    public func fetchUserDefaultKeyword(with key: String) -> [String] {
        return self.userDefault.getString(key)
    }
    
    public func setUserDefaultKeyword(with key: String, value: [String]) {
        self.userDefault.setString(key, value: value)
    }
}
