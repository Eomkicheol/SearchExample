//
//  SearchReactorTests.swift
//  
//
//  Created by 엄기철 on 2023/04/04.
//

import XCTest

import RxSwift

import Networking
import Entitys
import DomainEntity

@testable import Search

final class SearchReactorTests: XCTestCase {
    
    var useCase: SearchUseCase!
    var repositroy: SearchRepositoryMock!
    var disposeBag: DisposeBag!
    var sut: SearchReactor!
    
    override func setUpWithError() throws {
        self.repositroy = SearchRepositoryMock()
        self.useCase = SearchUseCase(repository: repositroy)
        self.disposeBag = .init()
        self.sut = SearchReactor(useCase: useCase, maker: SearchSectionMaker())
    }
    
    override func tearDownWithError() throws {
        self.repositroy = nil
        self.useCase = nil
        self.disposeBag = nil
        self.sut = nil
    }
    
    // given initial state when action then expect(state)
    
    func test_fetchSearchKeywords_called_test() {
        // given

        var list = ["1", "2"]
        
        self.repositroy.fetchSearchKeywordsHandler = { list.reversed() }
        
        // when
        self.sut.action.onNext(.searchHistoryAll)
        
        // then
        XCTAssertEqual(self.repositroy.fetchSearchKeywordsHandlerCallCount, 1)
        
//        XCTAssertEqual(self.sut.currentState.searchSection[0].items, )
    }
}


// MARK: - Test Double

final class SearchRepositoryMock: SearchRepositoryProtocol {
    
    var searchKey: String  = ""
    
    var fetchSearchKeywordHandler: (_ keyword: String, _ limit: Int) -> Observable<[StoreDomainEntity]> = { _, _ in .just([]) }
    var fetchSearchKeywordHandlerCallCount: Int = 0
    
    var fetchSearchKeywordsHandler: () -> [String] = { return [] }
    var fetchSearchKeywordsHandlerCallCount: Int = 0
    
    var saveSearchKeywordsHandler: () -> Void = {}
    var saveSearchKeywordsHandlerCallCount: Int = 0
    
    
    func fetchSearchKeyword(with keyword: String, limit: Int) -> Observable<[StoreDomainEntity]> {
        fetchSearchKeywordHandlerCallCount += 1
        return fetchSearchKeywordHandler(keyword, limit)
    }
    
    func fetchSearchKeywords() -> [String] {
        fetchSearchKeywordsHandlerCallCount += 1
        return fetchSearchKeywordsHandler()
    }
    
    func saveSearchKeywords(value: [String]) {
        saveSearchKeywordsHandlerCallCount += 1
        saveSearchKeywords(value: value)
    }
}
