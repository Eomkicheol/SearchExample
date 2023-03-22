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
    var userDefault: StubUserDefault!
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
        self.sut.saveSearchKeywords(value: ["kakao"])
        
        // then
        XCTAssertEqual(self.userDefault.setStringCallCount, 1)
        XCTAssertEqual(self.userDefault.setStringParams?.value, ["kakao"])
    }
    
    func test_getUserDefaultTest() {
        // when
        let result = self.sut.fetchSearchKeywords()
        
        
        // then
        XCTAssertEqual(self.userDefault.getStringCellCount, 1)
        XCTAssertEqual(self.userDefault.dummyGetString, ["kakao"])
        XCTAssertEqual(self.userDefault.getString("Search"), result)
    }
}

extension SearchUsecaseTests {
    
    final class StubNetwork: NetworkType {
        func request<T>(_ target: TargetType) -> Single<T> where T : Decodable, T : Encodable {
            return .just("" as! T)
        }
    }
    
    final class StubUserDefault: UserDefaultProtocol {
        
        func getString(_ key: String) -> [String] {
            self.getStringCellCount += 1
            return self.dummyGetString
        }
        
        var getStringCellCount: Int = 0
        var dummyGetString: [String] = ["kakao"]
        
        var setStringCallCount: Int = 0
        var setStringParams: (key: String, value: [String])?
        
        func setString(_ key: String, value: [String]) {
            self.setStringCallCount += 1
            self.setStringParams = (key, value)
        }
    }
}
