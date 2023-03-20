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
    let userDefault: UserdefaultProtocol
    
    public init(listener: SearchListener?,
                repositroy: SearchRepositoryImpl,
                userDefault: UserdefaultProtocol) {
        self.listener = listener
        self.repositroy = repositroy
        self.userDefault = userDefault
    }
}

public struct SearchParameter: Parameter {
    public init() {}
}


public final class SearchBuilder: Builder<Dependency>, SearchBuildable {
    public func build(with parameter: Parameter) -> Controllable {
        let viewController = SearchViewController()
        
        guard let dependency = dependency as? SearchDependency else { return viewController }
        
        let useCase: SearchUseCase = SearchUseCase(repository: dependency.repositroy,
                                                           manager: dependency.userDefault)
        
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
