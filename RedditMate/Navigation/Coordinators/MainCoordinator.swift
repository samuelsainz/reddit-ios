//
//  MainCoordinator.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/7/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

/// Main coordinator for the app.
/// Use this coordinator to navigate through view controllers
class MainCoordinator: Coordinator, PostsCoordinator {
    
    var childCoordinators = [Coordinator]()
    
    var navController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navController = navigationController
    }
    
    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: false)
    }
    
    func showPostDetail(post: Post) {
        let vc = PostDetailViewController.instantiate()
        vc.coordinator = self
        vc.post = post
        navController.pushViewController(vc, animated: true)
    }
}
