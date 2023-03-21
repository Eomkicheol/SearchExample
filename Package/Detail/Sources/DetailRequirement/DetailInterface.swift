//
//  DetailInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation
import ModuleComponents




public protocol DetailParameterable: Parameter {
    var viewModel: StoreDomainEntity { get }
}

public protocol DetailBuildable: Buildable {
    func build(with parameter: DetailParameterable) -> Controllable
}

public protocol DetailListener: AnyObject {}


public protocol DetailControllerable: UIViewControllable {
    var listener: DetailListener? { get set }
}
