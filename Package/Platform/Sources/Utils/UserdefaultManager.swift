//
//  UserdefaultManager.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

public protocol UserdefaultImpl: AnyObject {
    func setString(_ key: String, value: [String])
    func getString(_ key: String) -> [String]
}

public class UserdefaultManager: UserdefaultImpl {
    
    public init() {}
    
    public func setString(_ key: String, value: [String]) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    public func getString(_ key: String) -> [String] {
        guard let value = UserDefaults.standard.value(forKey: key) as? [String] else { return [] }
        return value
    }
}


