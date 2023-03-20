//
//  SearchRouter.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import Foundation
import UIKit

import ModuleComponents
import DetailRequirement
import Detail

protocol SearchRoutable: Routable {
    func routeToDetail(with parameter: Parameter) -> Controllable?
}

final class SearchRouter: SearchRoutable {

    // MARK: - Property
    let builder: DetailBuildable
    
    
    // MARK: - Initializer
    init(builder: DetailBuildable) {
        self.builder = builder
    }
    
    // MARK: - Public
    func routeToDetail(with parameter: Parameter) -> Controllable? {
        guard let parameter = parameter as? DetailParameter else { return nil }
        return builder.build(with: parameter)
    }
}
