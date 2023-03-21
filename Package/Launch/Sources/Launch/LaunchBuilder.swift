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
    weak var listener: LaunchListener?
    public init(listener: LaunchListener?) {
        self.listener = listener
    }
}

public struct LaunchParameter: LaunchParameterable{
    public init() {}
}


public final class LaunchBuilder: Builder<LaunchDependency> , LaunchBuildable {
    public func build(with parameter: LaunchParameterable) -> Controllable {
        
        let viewController: LaunchViewController = LaunchViewController()
        
        let router: LaunchRoutable = LaunchRouter()
        
        //DI
        viewController.router = router
        viewController.listener = dependency.listener
        
        return viewController
    }
}
