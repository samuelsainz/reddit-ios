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
            
            DispatchQueue.main.async {
                self.view?.showPosts(posts, animated: true)
            }
        }
    }
    
    /// This method is invoked when a post is dismissed
    /// - Parameter uuid: Dismissed post unique identifier
    func postDismissed(uuid: UUID) {
        guard let index = self.posts?.firstIndex(where: { $0.identifier == uuid }) else {
            return
        }
        
        self.posts!.remove(at: index)
        self.view?.showPosts(self.posts!, animated: true)
    }
    
    func allPostsDimissed() {
        self.posts = []
        self.view?.showPosts([], animated: true)
    }
    
    /// This method is invoked when a post is selected
    /// - Parameter index: Selected post index
    func postSelected(index: Int) {
        guard index >= 0,
            index < (self.posts?.count ?? 0) else {
            return
        }
        
        var post = self.posts![index]
        post.wasRead = true
        self.posts![index] = post
        
        // Update cell status
        self.view?.showPosts(self.posts!, animated: false)
        
        // Show post detail
        self.view?.showPostDetail(post: post)
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
