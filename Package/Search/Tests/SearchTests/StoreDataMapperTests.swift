//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/22.
//

import XCTest

import RxSwift

import Networking
import Entitys
import DomainEntity

@testable import Search

final class StoreDataMapperTests: XCTestCase {
    
    var network: StubNetwork!
    var disposeBag: DisposeBag!
    var sut: SearchRepository!
    
    
    override func setUpWithError() throws {
        self.network = .init()
        self.disposeBag = .init()
        self.sut = .init(network: self.network,
                         dataMapper: StoreDataMapper(),
                         userDefault: StubUserDefault())
    }
    
    override func tearDownWithError() throws {
        self.network = nil
        self.disposeBag = nil
        self.sut = nil
    }
    
    func test_convertToDataMapper() {
        //given
        self.network.requestStub = .just(
            StoreEntity(
                resultCount: 1,
                items: [.init(trackId: 200)]
            )
        )
        
        let convetToData: StoreEntity = .init(resultCount: 1, items: [.init(trackId: 1000)])
        
        
        var expectedValue: [StoreDomainEntity]?
        
        //when
        self.sut.fetchSearchKeyword(with: "", limit: 0)
            .subscribe(onNext: { expectedValue = $0 })
            .disposed(by: self.disposeBag)
        
        
        
        let data = self.sut.toDataModel(domainModel: convetToData)
        
        // then
        
        XCTAssertEqual(expectedValue?.first?.trackId, data.first?.trackId)
    }
}


//MARK: - Test Double
extension StoreDataMapperTests {
    final class StubNetwork: NetworkType {
        
        var requestStub: Single<StoreEntity> = .never()
        
        func request<T>(_ target: TargetType) -> Single<T> where T : Decodable, T : Encodable {
            return self.requestStub as! Single<T>
        }
    }
    
    final class StubUserDefault: UserDefaultProtocol {
        func getString(_ key: String) -> [String] { return [] }
        func setString(_ key: String, value: [String]) {}
    }
    
    final class StubStoreDataMapper {
        
        var dataModelCallCount: Int = 0
        
        func toDataModel(domainModel: StoreEntity) -> [StoreEntity] {
            self.dataModelCallCount += 1
            return [StoreEntity(resultCount: 1, items: [.init(trackId: 200)])]
        }
    }
}
