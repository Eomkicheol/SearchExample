//
//  AppBuilder.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import ModuleComponents
import RootRequirement
import Root

public struct AppDependency {
    
    // MARK: - Property
    
    
    
    // MARK: - Initializer
    public init() {}
}

public struct AppParameter: Parameter {
    // MARK: - Property
    
    // MARK: - Initializer
    public init() { }
}

public protocol AppBuildable: Buildable {
    func build(with parameter: Parameter) -> Controllable
}

public final class AppBuilder: Builder<AppDependency>, AppBuildable {
    public func build(with parameter: Parameter) -> Controllable {
        
        let rootBuilder: RootBuildable = RootBuilder(RootDependency())
        
        let router: AppRoutable = AppRouter(rootBuilder: rootBuilder)
        
    
        let app: App = App(router: router)
        
        return app
    }
}


