//
//  PostDetailPresenter.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/8/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import UIKit

class PostDetailPresenter {
    
    weak var view: PostDetailView?
    var post: Post?
    
    lazy var imageFetcher = ImageFetcher()
    
    init(view: PostDetailView) {
        self.view = view
    }
    
    func setupViewWithPost(_ post: Post) {
        self.post = post
        
        guard let view = self.view else {
            return
        }
        
        view.setDate(text: post.dateString)
        view.setTitle(text: post.title)
        view.setAuthor(text: post.authorString)
        view.setSubreddit(text: post.subredditString) // TODO: get subreddit to be shown here
        view.setUpvotes(text: post.numUpsString)
        view.setComments(text: post.numCommentsString)
        
        if let image = post.images?.sourceImage, let decodedUrl = image.decodedUrl {
            view.setImageSize(ratio: image.width / image.height)
            view.showImageLoading()
            self.fetchPostImage(link: decodedUrl)
        }
    }
    
    func fetchPostImage(link: String) {
        guard let thumbnailURL = URL(string: link) else {
            return
        }
        
        let _ = self.imageFetcher.fetchImage(thumbnailURL) { result in
          do {
            let image = try result.get()
            DispatchQueue.main.async {
                self.view?.setImage(image)
            }
          } catch {
            print("Error when fetching image: " + thumbnailURL.absoluteString + error.localizedDescription)
          }
        }
    }
}
