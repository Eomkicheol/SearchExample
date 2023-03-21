//
//  SearchInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import Foundation
import ModuleComponents

public protocol SearchBuildable: Buildable {
    func build(with parameter: SearchParameter) -> Controllable
}

public protocol SearchListener: AnyObject {}

public protocol SearchControllerable: Controllable {
    var listener: SearchListener? { get set }
}

public struct SearchParameter {
    public init() {}
}
