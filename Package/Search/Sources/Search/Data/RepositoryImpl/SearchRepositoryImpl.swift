//
//  SearchRepositoryImpl.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation

import RxSwift
import Entitys

public protocol SearchRepositoryImpl {
    func fetchSearchKeyword(with keyword: String, limit: Int) -> Single<StoreEntity>
}
