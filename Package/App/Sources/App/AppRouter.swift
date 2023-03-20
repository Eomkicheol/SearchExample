//
//  AppRouter.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//


import ModuleComponents
import RootRequirement

protocol AppRoutable: Routable {
    func routeToRoot(with parameter: Parameter) -> Controllable
}

final class AppRouter: AppRoutable {
    // MARK: - Property
    
    // MARK: - Builder
    private let rootBuilder: RootBuildable
    
    
    
    // MARK: - Initializer
    init(rootBuilder: RootBuildable) {
        self.rootBuilder = rootBuilder
    }
    
    // MARK: - Route
    func routeToRoot(with parameter: Parameter) -> Controllable {
        rootBuilder.build(with: parameter)
    }
}
