//
//  PostsController.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/9/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

class PostsController {
    
    let limit = 50
    let pageSize = 20
    
    var count = 0
    var lastFetched: String?
    
    func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        let endpoint = Endpoint.bestPosts(limit: limit)
        PostsService.fetchPosts(endpoint: endpoint) { (response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let response = response else {
                let error = NSError(domain: "Data error domain. Network unavailable.", code: -7000, userInfo: nil)
                completion(nil, error)
                return
            }
            
            self.lastFetched = response.data.after
            self.count = response.data.dist
            
            let posts = response.data.children.map { $0.data }
            completion(posts, nil)
        }
    }
    
    func fetchNextPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        guard let after = lastFetched else {
            let error = NSError(domain: "Missing info domain. There is no info for the last fetched element.", code: -7001, userInfo: nil)
            completion(nil, error)
            return
        }
        
        let endpoint = Endpoint.bestPosts(limit: pageSize, count: count, after: after)
        
        PostsService.fetchPosts(endpoint: endpoint) { (response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let response = response else {
                let error = NSError(domain: "Data error domain. Network unavailable.", code: -7000, userInfo: nil)
                completion(nil, error)
                return
            }
            
            self.lastFetched = response.data.after
            self.count += response.data.dist
            
            let posts = response.data.children.map { $0.data }
            completion(posts, nil)
        }
    }
}
