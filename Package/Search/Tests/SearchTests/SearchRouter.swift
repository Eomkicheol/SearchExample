//
//  SearchRouter.swift
//  
//
//  Created by 엄기철 on 2023/04/03.
//

import XCTest
import ModuleComponents
import DetailRequirement
import DomainEntity

@testable import Search


final class SearchRouterTest: XCTestCase {
    
    var sut: SearchRouter!
    var viewModel: StoreDomainEntity!
    var builder: DetailBuilderMock!
    var viewController: DetailMockViewController!
    var listener: DetailListenerMock!
    
    override func setUp() {
        self.viewModel = .init(item: .init(trackId: 100))
        self.viewController = DetailMockViewController(uiviewController: UIViewController(),
                                                       listener: DetailListenerMock())
        self.builder = DetailBuilderMock(viewController: viewController)
        self.sut = SearchRouter(builder: self.builder)
        
    }
    
    override func tearDown() {
        self.sut = nil
        self.viewModel = nil
        self.builder = nil
        self.viewController = nil
        self.listener = nil
    }
    
    func test_MoveToDetailSuccess() {
        //given
        let detailParameter = DetailParameter(viewModel: self.viewModel)
        
        //when
        self.sut.routeToDetail(with: detailParameter)
        
        // then
        XCTAssertEqual(self.builder.builderCallCount, 1)
        
    }
}


class SearchRouterMock: SearchRoutable {
    
    var builder: DetailBuildable!
    
    
    
    init(builder: DetailBuildable) {
        self.builder = builder
    }
    
    func routeToDetail(with parameter: DetailRequirement.DetailParameter) -> Controllable {
        
        return self.builder.build(with: .init(viewModel: .init(item: .init(trackId: 100))))
    }
}

class DetailBuilderMock: DetailBuildable {
    var viewController: DetailControllerable!
    var builderCallCount: Int = 0
    init(viewController: DetailControllerable) {
        self.viewController = viewController
    }
    func build(with parameter: DetailRequirement.DetailParameter) -> ModuleComponents.Controllable {
        self.builderCallCount += 1
        return viewController
    }
}

class DetailMockViewController: DetailControllerable {
    var listener: DetailRequirement.DetailListener?
    
    var uiviewController: UIViewController
    
    init(uiviewController: UIViewController, listener: DetailRequirement.DetailListener) {
        self.uiviewController = uiviewController
        self.listener = listener
    }
}


class DetailListenerMock: DetailListener {}
