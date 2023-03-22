//
//  DetailBuilder.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation
import DetailRequirement
import ModuleComponents

public class DetailDependency {
    
    public init() {}
}


public final class DetailBuilder: Builder<DetailDependency>, DetailBuildable {
    public func build(with parameter: DetailParameter) -> Controllable {
        let viewController = DetailViewController()
        
    
        let router: DetailRoutable = DetailRouter()
        let reactor: DetailReactor = DetailReactor(item: parameter.viewModel)

        viewController.router = router
        viewController.reactor = reactor

        return viewController
    }
}

