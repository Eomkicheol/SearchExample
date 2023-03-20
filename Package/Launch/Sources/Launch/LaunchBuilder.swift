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

public struct LaunchParameter: Parameter {
    public init() {}
}


public final class LaunchBuilder: Builder<Dependency> , LaunchBuildable {
    public func build(with parameter: Parameter) -> Controllable {
        
        let viewController: LaunchViewController = LaunchViewController()
        
        guard let dependency = dependency as? LaunchDependency else { return viewController }
        
        let router: LaunchRoutable = LaunchRouter()
        
        //DI
        viewController.router = router
        viewController.listener = dependency.listener
        
        return viewController
    }
}
