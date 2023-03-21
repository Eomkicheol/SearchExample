//
//  UserdefaultManager.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation

public protocol UserDefaultProtocol: AnyObject {
    func setString(_ key: String, value: [String])
    func getString(_ key: String) -> [String]
}
