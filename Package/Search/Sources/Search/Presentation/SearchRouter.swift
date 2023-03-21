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


protocol SearchRoutable: Routable {
    func routeToDetail(with parameter: DetailParameter) -> Controllable
}

final class SearchRouter: SearchRoutable {

    // MARK: - Property
    let builder: DetailBuildable
    
    
    // MARK: - Initializer
    init(builder: DetailBuildable) {
        self.builder = builder
    }
    
    // MARK: - Public
    func routeToDetail(with parameter: DetailParameter) -> Controllable {
        return builder.build(with: parameter)
    }
}
