//
//  PostDetailView.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/8/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

protocol PostDetailView: class {
    /// Show time since was published
    func setDate(text: String)
   
    /// Show the Post's title
    func setTitle(text: String)
    
    /// Show author username
    func setAuthor(text: String)
    
    /// Show subreddit tag
    func setSubreddit(text: String)
    
    /// Show how many upvotes has the post
    func setUpvotes(text: String)
    
    /// Show how many comments has the post
    func setComments(text: String)
    
    /// Show the post's image
    func setImage(_ image: UIImage)
    
    /// Set size for the image
    func setImageSize(ratio: Float)
    
    /// Show an activity indicator while downloading the image
    func showImageLoading()
}
