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
import Launch

import Search
import SearchRequirement

import Utils
import Networking


public class RootDependency: Dependency {
    
    public init() {}
}

public struct RootParameter: Parameter {}


public final class RootBuilder: Builder<Dependency>, RootBuildable {
    public func build(with parameter: Parameter) -> Controllable {
        let viewController = RootViewController()
        
        let launchBuilder: LaunchBuildable = LaunchBuilder(
            LaunchDependency(listener: viewController)
        )
        
        let network: NetworkType = Network()
        let repositroy: SearchRepositoryImpl = SearchRepository(network: network)
        let userDefault: UserdefaultProtocol = UserdefaultManager()
        
        let searchBuilder: SearchBuildable = SearchBuilder(SearchDependency(listener: viewController,
                                                                            repositroy: repositroy,
                                                                            userDefault: userDefault))
        
        let router: RootRoutable = RootRouter(launchBuilder: launchBuilder,
                                              searchBuilder: searchBuilder)
        
        viewController.router = router
        
        
        return viewController
    }
}

