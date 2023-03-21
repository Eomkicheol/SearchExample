//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//


import RxSwift
import Utils
import DomainEntity


public class SearchUseCase {
    
    private let repository: SearchRepositoryImpl
    private let manager: UserdefaultImpl
    private let dataMapper: StoreDataMapperImpl
    
    public init(repository: SearchRepositoryImpl,
                manager: UserdefaultImpl,
                dataMapper: StoreDataMapperImpl) {
        self.repository = repository
        self.manager = manager
        self.dataMapper = dataMapper
    }
    
    public func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<[StoreDomainEntity]> {
        return repository.fetchSearchKeyword(with: keyword, limit: limit)
            .map { [weak self] item -> [StoreDomainEntity] in
                guard let self = self else { return [] }
                let task = self.dataMapper.toDataModel(domainModel: item)
                return task
            }
    }
    
    public func fetchUserDefaultKeyword(with key: String) -> [String] {
        return self.manager.getString(key)
    }
    
    public func setUserDefaultKeyword(with key: String, value: [String]) {
        self.manager.setString(key, value: value)
    }
}
