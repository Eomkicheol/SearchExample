//
//  LaunchInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import ModuleComponents
import UIKit

public enum LaunchState {
    case completed
}

public struct LaunchParameter {
    public init() {}
}

public protocol LaunchBuildable: Buildable {
    func build(with parameter: LaunchParameter) -> Controllable
}


public protocol LaunchListener: AnyObject {
    func launch(_ launchController: Controllable, didComplete state: LaunchState)
}

public protocol LaunchControllable: Controllable, UINavigationControllerDelegate {
    var listener: LaunchListener? { get set }
}
