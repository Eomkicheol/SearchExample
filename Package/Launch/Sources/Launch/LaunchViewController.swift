//
//  LaunchViewController.swift
//  
//
//  Created by 엄기철 on 2023/03/18.
//

import Foundation
import UIKit

import ModuleComponents
import LaunchRequirement

final class LaunchViewController: UIViewController, LaunchControllable {
  
    // MARK: - View
    private let contentView = LaunchView()
    
    // MARK: - Property
    var router: LaunchRoutable?
    
    weak var listener: LaunchListener?
    
    // MARK: - Initializer

    // MARK: - Lifecycle
    override func loadView() {
        self.view = contentView
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moveToMain()
    }
    
    // MARK: - Public

    // MARK: - Private
    private func moveToMain() {
        Timer.scheduledTimer(withTimeInterval: 2,
                             repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.listener?.launch(self, didComplete: .completed)
        }
    }
}


extension LaunchViewController {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        LaunchAnimator()
    }
}
