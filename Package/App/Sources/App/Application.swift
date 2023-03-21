//
//  App.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import UIKit

import ModuleComponents
import RootRequirement


public protocol AppControllable: AnyObject, Controllable {
    var window: UIWindow? { get }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
}

final class App: AppControllable {
    // MARK: - Property
    var window: UIWindow?
    var router: AppRoutable
    
    // MARK: - Initializer
    init(router: AppRoutable) {
        self.router = router
    }
    
    // MARK: - Lifecycle
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setUpApplication()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        guard let  root = router.routeToRoot() as? RootControllerable else {
            return
        }

        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController =  root
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUpApplication() {}
}



