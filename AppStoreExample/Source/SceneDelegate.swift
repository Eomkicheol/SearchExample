//
//  SceneDelegate.swift
//  AppStoreExample
//
//  Created by 엄기철 on 2023/03/18.
//

import UIKit
import Foundation

import AppRequirement
import App

import RootRequirement
import Root

import LaunchRequirement
import Launch

import SearchRequirement
import Search

import DetailRequirement
import Detail

import Networking


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private var app: AppControllable?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        let dependency = self.makerAppDependency()
        
        let builder: AppBuildable = AppBuilder(dependency)
        
        guard let app: AppControllable = builder.build(with: AppParameter()) as? AppControllable else { return }
        
        self.app = app
        app.scene(scene, willConnectTo: session, options: connectionOptions)
    }
}


extension SceneDelegate {
    private func makerAppDependency() -> AppDependency {
        
        let repository = self.makerRepository()
        
        let launchBuilder: LaunchBuildable = LaunchBuilder(LaunchDependency())
        let detailBuilder: DetailBuildable = DetailBuilder(DetailDependency())
        let searchBuilder: SearchBuildable = SearchBuilder(SearchDependency(repositroy: repository,
                                                                            detailBuilder: detailBuilder))
        
        
        let rootBuilder: RootBuildable = RootBuilder(RootDependency(launchBuilder: launchBuilder,
                                                                    searchBuilder: searchBuilder,
                                                                    detailBuilder: detailBuilder))
        return AppDependency(listener: self,
                      rootBuilder: rootBuilder,
                      launchBuilder: launchBuilder,
                      searchBuilder: searchBuilder,
                      detailBuilder: detailBuilder)
    }
    
    private func makerRepository() -> SearchRepositoryProtocol {
        let network: NetworkType = Network()
        let datmMapper = StoreDataMapper()
        let userDefault: UserDefaultProtocol = UserdefaultManager()
        let repository: SearchRepositoryProtocol = SearchRepository(network: network,
                                                                dataMapper: datmMapper,
                                                                userDefault: userDefault)
        
        return repository
    }
}


extension SceneDelegate: AppListener {}

