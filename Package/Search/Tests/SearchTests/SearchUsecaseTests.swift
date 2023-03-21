//
//  File.swift
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
    var userDefault: SpyUserdefaultImpl!
    var sut: SearchUseCase!
    
    override func setUpWithError() throws {
        self.userDefault = .init()
        self.repository = .init(
            network: DummyNetwork(),
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
        self.sut.setUserDefaultKeyword(with: "111", value: ["222"])
        
        // then
        XCTAssertEqual(self.userDefault.setStringCallCount, 1)
        XCTAssertEqual(self.userDefault.setStringParams?.key, "111")
        XCTAssertEqual(self.userDefault.setStringParams?.value, ["222"])
    }
    
    func test_getUserDefaultTest() {
        // when
        let result = self.sut.fetchUserDefaultKeyword(with: "11")
        
        
        // then
        XCTAssertEqual(self.userDefault.getStringCellCount, 1)
        XCTAssertEqual(self.userDefault.deumygetString, ["kakao"])
    }
}

extension SearchUsecaseTests {
    
    final class DummyNetwork: NetworkType {
        func request<T>(_ target: TargetType) -> Single<T> where T : Decodable, T : Encodable {
            return .just("" as! T)
        }
    }
    
    final class SpyUserdefaultImpl: UserdefaultImpl {
        
        func getString(_ key: String) -> [String] {
            self.getStringCellCount += 1
            return self.deumygetString
        }
        
        var getStringCellCount: Int = 0
        var deumygetString: [String] = ["kakaao"]
        
        var setStringCallCount: Int = 0
        var setStringParams: (key: String, value: [String])?
        
        func setString(_ key: String, value: [String]) {
            self.setStringCallCount += 1
            self.setStringParams = (key, value)
        }
    }
}
