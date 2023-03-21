//
//  LaunchBuilder.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

import ModuleComponents
import LaunchRequirement

public struct LaunchDependency: Dependency {
    
    public init() {}
}




public final class LaunchBuilder: Builder<LaunchDependency> , LaunchBuildable {
    public func build(with parameter: LaunchParameter) -> Controllable {
        
        let viewController: LaunchViewController = LaunchViewController()
        
        let router: LaunchRoutable = LaunchRouter()
        
        //DI
        viewController.router = router
        
        return viewController
    }
}
