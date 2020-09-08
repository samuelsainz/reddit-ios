//
//  SplitMainCoordinator.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/8/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class SplitMainCoordinator: SplitCoordinator, PostsCoordinator {
    
    var childCoordinators = [Coordinator]()
    var navController = UINavigationController()
    
    var splitController: UISplitViewController
    
    init(splitViewController: UISplitViewController) {
        self.splitController = splitViewController
    }
    
    func start() {
        let homeVC = HomeViewController.instantiate()
        homeVC.coordinator = self
        navController.pushViewController(homeVC, animated: false)
        splitController.viewControllers = [navController]
    }
    
    func showPostDetail(post: Post) {
        let detailVC = PostDetailViewController.instantiate()
        detailVC.post = post
        splitController.viewControllers = [navController, detailVC]
    }
}
