//
//  Buildable.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

public protocol Dependency { }

public protocol Buildable { }

open class Builder<Dependency>: Buildable {
    public let dependency: Dependency

    public init(_ dependency: Dependency) {
        self.dependency = dependency
    }
}
