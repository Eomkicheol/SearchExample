//
//  DetailInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/20.
//

import Foundation
import ModuleComponents

public protocol DetailBuildable: Buildable {
    func build(with parameter: Parameter) -> Controllable
}


public protocol DetailListener: AnyObject {}
