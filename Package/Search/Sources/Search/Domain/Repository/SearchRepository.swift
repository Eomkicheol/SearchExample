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


public struct SearchRepository: SearchRepositoryImpl  {
    private let network: NetworkType
    
    public init(network: NetworkType) {
        self.network = network
    }
    
    public func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<StoreEntity> {
        return self.network.request(SearchApi.search(keyword: keyword, limit: limit))
            .asObservable()
    }
}
