//
//  Component.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

open class Component<DependencyType>: Dependency {
    public let dependency: DependencyType
    
    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}
