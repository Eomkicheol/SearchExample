//
//  RootInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import ModuleComponents

public protocol RootBuildable: AnyObject {
    func build() -> Controllable
}
public protocol RootControllerable: Controllable {}

public protocol RootParameterable {}
