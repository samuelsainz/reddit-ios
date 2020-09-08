//
//  Coordinator.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/7/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    
    /// Child coordinators corresponding to another flows started by this coordinator
    var navController: UINavigationController { get set }
    
    /// The NavigationController for this coordinator
    var childCoordinators: [Coordinator] { get set }
    
    /// Use this method to start this coordinator
    /// First view controller is created and added as the root for the navController
    func start()
}
