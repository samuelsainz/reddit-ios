//
//  PostTests.swift
//  RedditMateTests
//
//  Created by Samuel Sainz on 9/9/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import XCTest
@testable import RedditMate

class PostTests: XCTestCase {
    
    let mockPost = Post(name: "Name", title: "title", author: "author", ups: 12, subreddit: "subreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 328, wasRead: false, images: PostImages(images: [PostImage(source: ImageData(url: "http://imageurl", width: 200, height: 200))]))
    
    func testAuthorString() {
        // Given a post
        let post = Post(name: "Name", title: "title", author: "SamUY7", ups: 12, subreddit: "subreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 328, wasRead: false, images: nil)
        
        // When getting the author string
        let authorString = post.authorString
        
        // Then
        XCTAssertEqual(authorString, "by u/SamUY7")
    }
    
    func testSubredditString() {
        // Given a post
        let post = Post(name: "Name", title: "title", author: "SamUY7", ups: 12, subreddit: "SomeSubreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 328, wasRead: false, images: nil)
        
        // When getting the subreddit string
        let subredditString = post.subredditString
        
        // Then
        XCTAssertEqual(subredditString, "r/SomeSubreddit")
    }
    
    func testNumCommentsString() {
        // Given a post
        let postWithKcomments = Post(name: "Name", title: "title", author: "SamUY7", ups: 12, subreddit: "SomeSubreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 1520, wasRead: false, images: nil)
        
        let postWithAFewComments = Post(name: "Name", title: "title", author: "SamUY7", ups: 12, subreddit: "SomeSubreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 12, wasRead: false, images: nil)
        
        // When getting the string with the number of comment
        let numCommentsString = postWithKcomments.numCommentsString
        let fewCommentsString = postWithAFewComments.numCommentsString
        
        XCTAssertEqual(numCommentsString, "1.5K")
        XCTAssertEqual(fewCommentsString, "12")
    }
    
    func testNumUpVotesString() {
        // Given a post
        let postWithKups = Post(name: "Name", title: "title", author: "SamUY7", ups: 8373, subreddit: "SomeSubreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 1520, wasRead: false, images: nil)
        
        let postWithAFewUps = Post(name: "Name", title: "title", author: "SamUY7", ups: 12, subreddit: "SomeSubreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 12, wasRead: false, images: nil)
        
        // When getting the string with the number of comment
        let numUpsString = postWithKups.numUpsString
        let fewUpsString = postWithAFewUps.numUpsString
        
        XCTAssertEqual(numUpsString, "8.4K")
        XCTAssertEqual(fewUpsString, "12")
    }
}
