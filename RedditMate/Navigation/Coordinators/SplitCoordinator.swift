//
//  SplitCoordinator.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/8/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

/// Coordinator protocol for splitted screen (iPad)
protocol SplitCoordinator: Coordinator {
    
    var splitController: UISplitViewController { get set }
}
