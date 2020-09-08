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
    var navController: UINavigationController { get set }
    var subCoordinators: [Coordinator] { get set }
    
    func start()
}
