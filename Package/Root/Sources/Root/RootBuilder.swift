//
//  RootBuilder.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

import ModuleComponents
import RootRequirement
import LaunchRequirement
import SearchRequirement
import DetailRequirement


public class RootDependency: Dependency {
    
    let launchBuilder: LaunchBuildable
    let searchBuilder: SearchBuildable
    let detailBuilder: DetailBuildable

    public init(launchBuilder: LaunchBuildable, searchBuilder: SearchBuildable,
                detailBuilder: DetailBuildable) {
        self.launchBuilder = launchBuilder
        self.searchBuilder = searchBuilder
        self.detailBuilder = detailBuilder
    }
}

public struct RootParameter: RootParameterable {}


public final class RootBuilder: Builder<RootDependency>, RootBuildable {
    public func build() -> Controllable {
        let viewController = RootViewController()
        
        let router: RootRoutable = RootRouter(launchBuilder: dependency.launchBuilder,
                                              searchBuilder: dependency.searchBuilder)
        
        viewController.router = router
        
        
        return viewController
    }
    
}
