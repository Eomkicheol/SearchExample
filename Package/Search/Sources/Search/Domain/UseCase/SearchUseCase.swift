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
    
    public func fetchSearchKeywords() -> [String] {
        return repository.fetchSearchKeywords()

    }
    
    public func saveSearchKeywords(value: [String]) {
        repository.saveSearchKeywords(value: value)
    }
}
