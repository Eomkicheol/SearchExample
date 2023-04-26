//
//  SearchUsecaseTests.swift
//  
//
//  Created by 엄기철 on 2023/03/21.
//

import XCTest
import RxSwift

import Networking
@testable import Search

final class SearchUsecaseTests: XCTestCase {

    var repository: SearchRepository!
    var userDefault: SpyUserDefault!
    var sut: SearchUseCase!
    
    override func setUpWithError() throws {
        self.userDefault = .init()
        self.repository = .init(
            network: StubNetwork(),
            dataMapper: StoreDataMapper(),
            userDefault: self.userDefault
        )
        self.sut = .init(repository: self.repository)
    }
    
    override func tearDownWithError() throws {
        self.repository = nil
        self.userDefault = nil
        self.sut = nil
    }
    
    func test_saveUserDefaultTest() {
        // when
        self.sut.saveSearchKeywords(value: ["1", "2", "3"])

        // then
        XCTAssertEqual(self.userDefault.setStringCallCount, 1)
        XCTAssertEqual(self.userDefault.setStringParams?.value, ["1", "2", "3"])
    }

    func test_getUserDefaultTest() {
        // when
        let result = self.sut.fetchSearchKeywords()


        // then
        XCTAssertEqual(self.userDefault.getStringCellCount, 1)
        XCTAssertEqual(self.userDefault.dummyGetString, ["1", "2", "3"])
        XCTAssertEqual(self.userDefault.getString("Search"), result)
    }
    
    func test_saveAllHistoryKeyword() {
        //given
        let expectedValue: [String] = ["3", "2", "1"]
        
        //when
        self.sut.saveSearchKeywords(value: ["1", "2", "3"])
        let result = self.sut.saveHistoryKeywordAll()
        
        //then
        XCTAssertEqual(expectedValue, result)
    }
    
    func test_updateSearchKeyword() {
        //given
        
        let keyword: String = "카카오"
        let expectedValue: [String] = ["1", "2", "3", "카카오"]
        
        // when
        let previousList: [String] = self.sut.fetchSearchKeywords()
        let result = self.sut.updateSearchKeyword(keyword: keyword, previousList: previousList)
        
        //then
        XCTAssertEqual(expectedValue, result)
    }
    
//    func testAppendSearchKeyword() {
//        //given
//        let keywork: String = "카카오"
//        let expectedValue: [String] = ["1", "2", "3", "카카오"]
//
//        //when
//        let previousList: [String] = self.sut.fetchSearchKeywords()
//        let result = self.sut.appendSearchKeyword(keyword: keywork, previousList: previousList)
//
//        //then
//        XCTAssertEqual(expectedValue, result)
//    }
}

extension SearchUsecaseTests {
    
    final class StubNetwork: NetworkType {
        var requestStub: Single<String> = .never()
        
        func request<T>(_ target: TargetType) -> Single<T> where T : Decodable, T : Encodable {
           return requestStub as! Single<T>
        }
    }
    
    final class SpyUserDefault: UserDefaultProtocol {
        
        func getString(_ key: String) -> [String] {
            self.getStringCellCount += 1
            return self.dummyGetString
        }
        
        var getStringCellCount: Int = 0
        var dummyGetString: [String] = ["1", "2", "3"]
        
        var setStringCallCount: Int = 0
        var setStringParams: (key: String, value: [String])?
        
        func setString(_ key: String, value: [String]) {
            self.setStringCallCount += 1
            self.setStringParams = (key, value)
        }
    }
}
