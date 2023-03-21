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

public struct DetailParameter {
    
    let viewModel: StoreDomainEntity
    
    public init(viewModel: StoreDomainEntity) {
        self.viewModel = viewModel
    }
    
}


public final class DetailBuilder: Builder<Dependency>, DetailBuildable {
    public func build(with parameter: Parameter) -> Controllable {
        let viewController = DetailViewController()
        
        guard let dependency = dependency as? DetailDependency else { return viewController }
        
        
        
        let router: DetailRoutable = DetailRouter()
        let reactor: DetailReactor = DetailReactor(item: )


        viewController.router = router
        viewController.reactor = reactor
        viewController.listener = dependency.listener

        return viewController
    }
}

