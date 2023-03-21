//
//  RootRouter.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import UIKit

import ModuleComponents
import LaunchRequirement

import SearchRequirement


protocol RootRoutable: Routable {
    func routeToLaunch(with parameter: LaunchParameterable) -> Controllable
    func routeToSearch(with parameter: SearchParameterable) -> Controllable
}

final class RootRouter: RootRoutable {
    
    // MARK: - Property
    private let launchBuilder: LaunchBuildable
    private let searchBuilder: SearchBuildable
    
    // MARK: - Initializer
    init(launchBuilder: LaunchBuildable,
         searchBuilder: SearchBuildable) {
        self.launchBuilder = launchBuilder
        self.searchBuilder = searchBuilder
    
    }
    
    // MARK: - Public
    func routeToLaunch(with parameter: LaunchParameterable) -> Controllable {
        launchBuilder.build(with: parameter)
    }
    
    func routeToSearch(with parameter: SearchParameterable) -> Controllable {
        searchBuilder.build(with: parameter)
    }
}

