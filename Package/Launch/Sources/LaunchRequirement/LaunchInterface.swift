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

public protocol LaunchBuildable: Buildable {
    func build(with parameter: LaunchParameterable) -> Controllable
}

public protocol LaunchParameterable {}

public protocol LaunchListener: AnyObject {
    func launch(_ launchController: Controllable, didComplete state: LaunchState)
}

public protocol LaunchControllable: UIViewControllable, UINavigationControllerDelegate {
    var listener: LaunchListener? { get set }
}
