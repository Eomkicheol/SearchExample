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
    
    public func saveHistoryKeywordAll() -> [String] {
        let previousList: [String] = self.fetchSearchKeywords()
        return previousList.reversed()
    }
    
    
    public func updateSearchKeyword(keyword: String, previousList: [String]) -> [String] {
        var result = previousList
        
        if let index = result.firstIndex(where: { $0 == keyword}) {
            result.remove(at: index)
        }
        result.append(keyword)
        self.saveSearchKeywords(value: result)
        return result
    }
}
