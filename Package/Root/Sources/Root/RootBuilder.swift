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
import SearchRequirement
import Search

import Utils
import Networking


public class RootDependency: Dependency {
    
    public init() {}
}

public struct RootParameter: RootParameterable {}


public final class RootBuilder: Builder<RootDependency>, RootBuildable {
    public func build() -> Controllable {
        let viewController = RootViewController()
        
        let launchBuilder: LaunchBuildable = LaunchBuilder(
            LaunchDependency(listener: viewController)
        )
        
        let network: NetworkType = Network()
        let repositroy: SearchRepositoryImpl = SearchRepository(network: network)
        let userDefault: UserdefaultImpl = UserdefaultManager()
        let dataMapper: StoreDataMapperImpl = StoreDataMapper()
        
        let searchBuilder: SearchBuildable = SearchBuilder(SearchDependency(listener: viewController,
                                                                            repositroy: repositroy,
                                                                            userDefault: userDefault, dataMapper: dataMapper))
        
        let router: RootRoutable = RootRouter(launchBuilder: launchBuilder,
                                              searchBuilder: searchBuilder)
        
        viewController.router = router
        
        
        return viewController
    }
    
}

