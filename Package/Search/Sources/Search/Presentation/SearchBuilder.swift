//
//  SearchBuilder.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import Foundation
import SearchRequirement
import ModuleComponents
import Utils
import DetailRequirement


public class SearchDependency: Dependency {
    
    let repositroy: SearchRepositoryProtocol
    let detailBuilder: DetailBuildable
    
    public init(repositroy: SearchRepositoryProtocol, detailBuilder: DetailBuildable) {
        self.repositroy = repositroy
        self.detailBuilder = detailBuilder
    }
}

public final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {
    public func build(with parameter: SearchParameter) -> ModuleComponents.Controllable {
        let viewController = SearchViewController()
        
        let useCase: SearchUseCase = SearchUseCase(repository: dependency.repositroy)
        
        let router: SearchRoutable = SearchRouter(builder: dependency.detailBuilder)
        let reactor: SearchReactor = SearchReactor(useCase: useCase, maker: .init())
        
        viewController.router = router
        viewController.reactor = reactor
        return viewController
    }
}
