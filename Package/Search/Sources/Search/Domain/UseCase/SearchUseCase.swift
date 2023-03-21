//
//  SearchUseCase.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//


import RxSwift
import Utils
import DomainEntity

public class SearchUseCase {
    
    private let repository: SearchRepositoryProtocol
    
    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<[StoreDomainEntity]> {
        return repository.fetchSearchKeyword(with: keyword, limit: limit)
    }
    
    public func fetchUserDefaultKeyword(with key: String) -> [String] {
        return repository.fetchUserDefaultKeyword(with: key)
    }
    
    public func setUserDefaultKeyword(with key: String, value: [String]) {
        repository.setUserDefaultKeyword(with: key, value: value)
    }
}
