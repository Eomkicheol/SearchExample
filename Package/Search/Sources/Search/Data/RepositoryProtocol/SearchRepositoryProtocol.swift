//
//  SearchRepositoryProtocol.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation

import RxSwift
import DomainEntity

public protocol SearchRepositoryProtocol {
    func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<[StoreDomainEntity]>
    func fetchSearchKeywords() -> [String]
    func saveSearchKeywords(value: [String])
    var searchKey: String { get }
}
