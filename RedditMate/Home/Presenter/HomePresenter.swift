//
//  HomePresenter.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/5/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation
import UIKit

class HomePresenter {
    
    weak var view: HomeView?
    
    var posts: [Post]?
    
    lazy var imageFetcher: ImageFetcher = ImageFetcher()
    
    init(view: HomeView) {
        self.view = view
    }
    
    // MARK: Posts management
    
    /// Get the posts and update the view
    func fetchPosts() {
        PostsService.fetchPosts() { (posts, error) in
            guard error == nil else {
                // TODO: Show error view
                return
            }
            
            guard let posts = posts else {
                return
            }
            
            self.posts = posts
            self.view?.showPosts(posts)
        }
    }
    
    /// This method is invoked when a post is dismissed
    /// - Parameter index: Dismissed post index
    func postDismissed(index: Int) {
        // TODO: validate index
        self.posts?.remove(at: index)
        self.view?.showPosts(self.posts!)
    }
    
    /// This method is invoked when a post is selected
    /// - Parameter index: Selected post index
    func postSelected(index: Int) {
        // TODO: validate index
        // TODO: navigate
        var post = self.posts![index]
        self.view?.showPostDetail(post: post)
        post.wasRead = true
        // TODO update cell
    }
    
    // MARK: Images management
    
    /// Fetch a post's image and return an identifier for that transaction
    /// Cancel this request using the returned token when cell is reused
    func fetchPostImage(urlString: String, completion: @escaping (UIImage) -> Void) -> UUID? {
        guard let thumbnailURL = URL(string: urlString) else {
            return nil
        }
        
        return self.imageFetcher.fetchImage(thumbnailURL) { result in
          do {
            let image = try result.get()
            completion(image)
          } catch {
            print("Error when fetching image: " + thumbnailURL.absoluteString + error.localizedDescription)
          }
        }
    }
    
    /// Cancel the image fetch if it's not finished yet
    /// - Parameter token: The unique token that identifies the request to be cancelled
    func cancelPostImageFetch(token: UUID?) {
        guard let token = token else {
            return
        }
        
        self.imageFetcher.cancelLoad(token)
    }
}
