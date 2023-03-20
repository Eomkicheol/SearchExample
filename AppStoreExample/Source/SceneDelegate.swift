//
//  SceneDelegate.swift
//  AppStoreExample
//
//  Created by 엄기철 on 2023/03/18.
//

import UIKit

import App

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var app: AppControllable?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        

        let builder: AppBuildable = AppBuilder(AppDependency())
        
        guard let app: AppControllable = builder.build(with: AppParameter()) as? AppControllable else { return }
        
        self.app = app
        app.scene(scene, willConnectTo: session, options: connectionOptions)
    }
}
