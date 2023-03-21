//
//  DetailBuilder.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation
import DetailRequirement
import ModuleComponents
import DomainEntity

public class DetailDependency {
    
    weak var listener: DetailListener?
    
    public init(listener: DetailListener?) {
        self.listener = listener
    }
}

public struct DetailParameter: DetailParameterable  {
    public var viewModel: StoreDomainEntity
    
    public init(viewModel: StoreDomainEntity) {
        self.viewModel = viewModel
    }
}



public final class DetailBuilder: Builder<DetailDependency>, DetailBuildable {
    public func build(with parameter: DetailParameterable) -> Controllable {
        let viewController = DetailViewController()
        
    
        let router: DetailRoutable = DetailRouter()
        let reactor: DetailReactor = DetailReactor(item: parameter.viewModel)


        viewController.router = router
        viewController.reactor = reactor
        viewController.listener = dependency.listener

        return viewController
    }
}

