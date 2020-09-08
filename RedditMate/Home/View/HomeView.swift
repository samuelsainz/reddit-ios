//
//  HomeView.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

protocol HomeView: class {
    
    /// Show `posts` in `HomeView`
    func showPosts(_ posts: [Post])
    
    /// Show the `post` detail
    func showPostDetail(post: Post)
}
