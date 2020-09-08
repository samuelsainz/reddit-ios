//
//  PostsCoordinator.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/8/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

/// This protocol defines the coordinator for Posts navigation
protocol PostsCoordinator: AnyObject {
    
    /// Shows Post Detail screen
    func showPostDetail(post: Post)
}
