//
//  DetailInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation
import ModuleComponents
import DomainEntity


public struct DetailParameter {
    public let viewModel: StoreDomainEntity
    
   public init(viewModel: StoreDomainEntity) {
        self.viewModel = viewModel
    }
}

public protocol DetailBuildable: Buildable {
    func build(with parameter: DetailParameter) -> Controllable
}

public protocol DetailListener: AnyObject {}


public protocol DetailControllerable: Controllable {
    var listener: DetailListener? { get set }
}
