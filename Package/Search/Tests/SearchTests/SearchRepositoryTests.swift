//
//  SearchRepositoryTests.swift
//  
//
//  Created by 엄기철 on 2023/03/21.
//

import XCTest

import RxSwift

import Networking
import Entitys
import DomainEntity

@testable import Search

final class SearchRepositoryTests: XCTestCase {
    
    var network: StubNetwork!
    var disposeBag: DisposeBag!
    var sut: SearchRepository!
    
    override func setUpWithError() throws {
        self.network = .init()
        self.disposeBag = .init()
        self.sut = .init(
            network: self.network,
            dataMapper: StoreDataMapper(),
            userDefault: DummyUserDefault()
        )
    }
    
    override func tearDownWithError() throws {
        self.network = nil
        self.disposeBag = nil
        self.sut = nil
    }
    
    func test_fetchSearchKeyword() {
        // given
        self.network.requestStub = .just(
            StoreEntity(
                resultCount: 1,
                items: [.init(trackId: 100)]
            )
        )
        var expectedValue: [StoreDomainEntity]?
        
        // when
        self.sut.fetchSearchKeyword(with: "", limit: 0)
            .subscribe(onNext: { expectedValue = $0 })
            .disposed(by: self.disposeBag)
        
        // then
        XCTAssertEqual(expectedValue?.first?.trackId, 100)
    }
}


// MARK: - Test Double

extension SearchRepositoryTests {
    
    final class StubNetwork: NetworkType {
        
        var requestStub: Single<StoreEntity> = .never()
        
        func request<T>(_ target: TargetType) -> Single<T> where T : Decodable, T : Encodable {
            return self.requestStub as! Single<T>
        }
    }
    
    final class DummyUserDefault: UserDefaultProtocol {
        func getString(_ key: String) -> [String] {
            return []
        }
        
        func setString(_ key: String, value: [String]) {}
    }
}


extension AppStoreItem {
    
    init(trackId: Int) {
        self.init(
            artworkUrl60: nil,
            artworkUrl100: nil,
            trackId: trackId,
            trackName: "",
            genres: [],
            screenshotUrls: [],
            userRatingCount: nil,
            contentAdvisoryRating: nil,
            languageCodesISO2A: [],
            sellerName: nil,
            releaseNotes: nil,
            version: nil,
            currentVersionReleaseDate: nil,
            description: nil,
            fileSizeBytes: nil,
            minimumOsVersion: nil,
            supportedDevices: [],
            averageUserRatingForCurrentVersion: nil
        )
    }
}
