//
//  Buildable.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

public protocol Dependency { }

    /// Define the parameters the module will use at start.
public protocol Parameter { }

    /// Define build function.
    /// e.g. func build(parameter: Parameter) -> Controllable
public protocol Buildable { }

open class Builder<Dependency>: Buildable {
    public let dependency: Dependency

    public init(_ dependency: Dependency) {
        self.dependency = dependency
    }
}
