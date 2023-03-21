//
//  SearchRepositoryImpl.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation

import RxSwift
import DomainEntity

public protocol SearchRepositoryImpl {
    func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<[StoreDomainEntity]>
    func fetchUserDefaultKeyword(with key: String) -> [String]
    func setUserDefaultKeyword(with key: String, value: [String])
}
