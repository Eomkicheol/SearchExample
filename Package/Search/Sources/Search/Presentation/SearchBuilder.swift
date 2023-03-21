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
import Detail

public class SearchDependency: Dependency {
    
    weak var listener: SearchListener?
    let repositroy: SearchRepositoryImpl
    let userDefault: UserdefaultImpl
    let dataMapper: StoreDataMapperImpl
    
    public init(listener: SearchListener?,
                repositroy: SearchRepositoryImpl,
                userDefault: UserdefaultImpl,
                dataMapper: StoreDataMapperImpl) {
        self.listener = listener
        self.repositroy = repositroy
        self.userDefault = userDefault
        self.dataMapper = dataMapper
    }
}

public struct SearchParameter: SearchParameterable {
    public init() {}
}


public final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {
    public func build(with parameter: SearchParameterable) -> ModuleComponents.Controllable {
        let viewController = SearchViewController()
        
        let useCase: SearchUseCase = SearchUseCase(repository: dependency.repositroy,
                                                   manager: dependency.userDefault,
                                                   dataMapper: dependency.dataMapper)
        
        let detailBuilder: DetailBuildable = DetailBuilder(
            DetailDependency(listener: viewController)
        )
        
        let router: SearchRoutable = SearchRouter(builder: detailBuilder)
        let reactor: SearchReactor = SearchReactor(useCase: useCase)
        
        viewController.router = router
        viewController.reactor = reactor
        return viewController
    }
}
