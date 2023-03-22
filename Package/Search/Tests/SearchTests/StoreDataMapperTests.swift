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
    
    var sut: StoreDataMapper!
    
    
    override func setUpWithError() throws {
        self.sut = .init()
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func test_convertToDataMapper() {
        //given
        let entity: StoreEntity = .init(resultCount: 1, items: [.init(trackId: 1000)])
        
        //when
            let data = self.sut.toDataModel(domainModel: entity)
        
        // then
        XCTAssertEqual(data.first?.trackId, 1000)
    }
}
