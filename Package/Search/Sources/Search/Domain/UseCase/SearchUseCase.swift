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
    private let manager: UserdefaultProtocol
    
    public init(repository: SearchRepositoryImpl,
                manager: UserdefaultProtocol) {
        self.repository = repository
        self.manager = manager
    }
    
    public func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<[StoreDomainEntity]> {
        return repository.fetchSearchKeyword(with: keyword, limit: limit)
            .asObservable()
            .map { $0.items.map {
                StoreDomainEntity(item: $0)
            } }
    }
    
    public func fetchUserDefaultKeyword(with key: String) -> [String] {
        return self.manager.getString(key)
    }
    
    public func setUserDefaultKeyword(with key: String, value: [String]) {
        self.manager.setString(key, value: value)
    }
}
