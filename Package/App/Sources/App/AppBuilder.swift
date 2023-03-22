//
//  AppBuilder.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import ModuleComponents
import AppRequirement

public final class AppBuilder: Builder<AppDependency>, AppBuildable {
    public func build(with parameter: AppParameter) -> Controllable {
        
        let router: AppRoutable = AppRouter(rootBuilder: dependency.rootBuilder)
        
        let app: App = App(router: router)
        
        return app
    }
}
