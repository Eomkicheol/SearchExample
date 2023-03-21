//
//  RootViewController.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import UIKit

import ModuleComponents
import LaunchRequirement
import SearchRequirement
import RootRequirement

final class RootViewController: UINavigationController, RootControllerable {
    
    // MARK: - View

    // MARK: - Property
    var router: RootRoutable?
    
    // MARK: - Initializer

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        self.view.backgroundColor = .white
    }
    
    private func setUpState() {
        presentLaunch(animated: false)
    }
    
    private func setUpAction() {
        
    }
    
    func presentLaunch(animated: Bool, completion: ((LaunchControllable) -> Void)? = nil ) {
        guard let launch = router?.routeToLaunch(with: LaunchParameter()) as? LaunchControllable else { return }
        
        launch.listener = self
        
        setViewControllers([launch.uiviewController], animated: animated)
        completion?(launch)
    }
    
    func presentSearch(animated: Bool, completion: ((SearchControllerable) -> Void)? = nil ) {
        
        guard let searchView = router?.routeToSearch(with: SearchParameter()) as? SearchControllerable else { return }
        searchView.listener = self
        self.setViewControllers([searchView.uiviewController], animated: animated)
        completion?(searchView)
        
        
    }

}

extension RootViewController: LaunchListener {
    func launch(_ launchController: Controllable, didComplete state: LaunchState) {
        self.presentSearch(animated: false)
    }
}

extension RootViewController: SearchListener {}

