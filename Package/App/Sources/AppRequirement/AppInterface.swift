//
//  AppInterface.swift
//  
//
//  Created by 엄기철 on 2023/03/21.
//

import Foundation
import UIKit

import ModuleComponents
import SearchRequirement
import LaunchRequirement
import RootRequirement
import DetailRequirement


public struct AppDependency {
    
    // MARK: - Property
    public weak var listener: AppListener?
    public let rootBuilder: RootBuildable
    public let launchBuilder: LaunchBuildable
    public let searchBuilder: SearchBuildable
    public let detailBuilder: DetailBuildable
    // MARK: - Initializer
    
    public init(listener: AppListener?, rootBuilder: RootBuildable,
                launchBuilder: LaunchBuildable, searchBuilder: SearchBuildable,
                detailBuilder: DetailBuildable) {
        self.listener = listener
        self.rootBuilder = rootBuilder
        self.launchBuilder = launchBuilder
        self.searchBuilder = searchBuilder
        self.detailBuilder = detailBuilder
    }
}

public struct AppParameter {
    // MARK: - Property
    // MARK: - Initializer
    public init() { }
}

public protocol AppBuildable: Buildable {
    func build(with parameter: AppParameter) -> Controllable
}


public protocol AppRoutable: Routable {
    func routeToRoot() -> Controllable
}

public protocol AppListener: AnyObject {}


public protocol AppControllable: AnyObject, Controllable {
    var window: UIWindow? { get }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
}
