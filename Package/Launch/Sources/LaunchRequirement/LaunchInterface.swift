//
//  LaunchInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import ModuleComponents

public enum LaunchState {
    case completed
}

public protocol LaunchBuildable: Buildable {
    func build(with parameter: Parameter) -> Controllable
}


public protocol LaunchListener: AnyObject {
    func launch(_ launchController: Controllable, didComplete state: LaunchState)
}
