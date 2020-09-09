//
//  PostsEndpoints.swift
//  RedditMate
//
//  Created by Samuel Sainz on 9/9/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import Foundation

extension Endpoint {
    
    /// This endpoint can be used for pagination, where we want to send count and after params.
    /// - Parameters:
    ///   - limit: The maximum number of items to return in this slice of the listing.
    ///   - count: The number of items already seen in this listing.
    ///   - after: Indicate the fullname of an item in the listing to use as the anchor point of the slice.
    /// - Returns: An Endpoint with all thata needed to make the request
    static func bestPosts(limit: Int, count: Int, after: String) -> Self {
        return Endpoint(path: "/best.json",
                        queryItems: [
                            URLQueryItem(name: "limit",
                                         value: "\(limit)"),
                            URLQueryItem(name: "count",
                                         value: "\(count)"),
                            URLQueryItem(name: "after",
                                         value: after)
        ])
    }
    
    /// This endpoint can be used to fetch the last best posts.
    /// - Parameters:
    ///   - limit: The maximum number of items to return in this slice of the listing.
    /// - Returns: An Endpoint with all thata needed to make the request
    static func bestPosts(limit: Int) -> Self {
        return Endpoint(path: "/best.json",
                        queryItems: [
                            URLQueryItem(name: "limit",
                                         value: "\(limit)"),
        ])
    }
}
