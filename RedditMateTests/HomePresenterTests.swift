//
//  HomePresenterTests.swift
//  RedditMateTests
//
//  Created by Samuel Sainz on 9/9/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import XCTest
@testable import RedditMate

class HomePresenterTests: XCTestCase {
    
    class HomeViewMock: HomeView {
        
        var showPostsCalled = false
        var showPostDetailCalled = false
        var showLoadingIndicatorCalled = false
        var hideLoadingIndicatorCalled = false
        var hideRefreshIndicatorCalled = false
        var showErrorCalled = false
        
        let showPostsExpectation = XCTestExpectation(description: "show posts called")
        let hideLoadingExpectation = XCTestExpectation(description: "hide loading called")
        let hideRefreshIndicatorExpectation = XCTestExpectation(description: "hide refresh indicator called")
        let showErrrorExpectation = XCTestExpectation(description: "show error called")
        
        func showPosts(_ posts: [Post], animated: Bool) {
            showPostsCalled = true
            showPostsExpectation.fulfill()
        }
        
        func showPostDetail(post: Post) {
            showPostDetailCalled = true
        }
        
        func showLoadingIndicator() {
            showLoadingIndicatorCalled = true
        }
        
        func hideLoadingIndicator() {
            hideLoadingIndicatorCalled = true
            hideLoadingExpectation.fulfill()
        }
        
        func hideRefreshIndicator() {
            hideRefreshIndicatorCalled = true
            hideRefreshIndicatorExpectation.fulfill()
        }
        
        func showError(message: String) {
            showErrorCalled = true
            showErrrorExpectation.fulfill()
        }
    }
    
    class MockPostsController: PostsController {
        
        var posts: [Post]?
        var error: Error?
        
        init(posts: [Post]?, error: Error?) {
            self.posts = posts
            self.error = error
        }
        
        override func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
            completion(self.posts, self.error)
        }
        
        override func fetchNextPosts(completion: @escaping ([Post]?, Error?) -> Void) {
            completion(self.posts, self.error)
        }
    }
    
    var postsMocks = [
        Post(name: "Name", title: "title", author: "author", ups: 12, subreddit: "subreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 328, wasRead: false, images: nil),
        Post(name: "Name2", title: "title2", author: "author2", ups: 12, subreddit: "subreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 328, wasRead: false, images: nil)
    ]
            
    func testPresenterLoadViewWithFetchedPosts() {
        // Given the presenter and the view
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        
        // When load view is called and posts are fetched
        presenter.postsController = MockPostsController(posts: self.postsMocks, error: nil)
        presenter.loadView()
        
        // Then
        XCTAssert(view.showLoadingIndicatorCalled)
        XCTAssertFalse(view.showErrorCalled)
        XCTAssertEqual(presenter.posts?.count, 2)
        wait(for: [view.showPostsExpectation, view.hideLoadingExpectation], timeout: 1)
    }
    
    func testPresenterLoadViewWithError() {
        // Given the presenter and the view
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        
        // When load view is called and an error occurs
        presenter.postsController = MockPostsController(posts: nil, error: NSError(domain: "test error", code: 1, userInfo: nil))
        presenter.loadView()
        
        // Then
        XCTAssert(view.showLoadingIndicatorCalled)
        XCTAssertNil(presenter.posts)
        XCTAssertFalse(view.showPostsCalled)
        // These functions are dispatched async at the main thread
        wait(for: [view.showErrrorExpectation, view.hideLoadingExpectation], timeout: 1)
    }
    
    func testRefreshRequestedWithPosts() {
        // Given the presenter and the view, showing already two posts
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        presenter.posts = self.postsMocks
        
        // When refreshing requested and posts are returned
        presenter.postsController = MockPostsController(posts: self.postsMocks, error: nil)
        presenter.refreshRequested()
        
        // Then
        XCTAssertFalse(view.showErrorCalled)
        XCTAssertEqual(presenter.posts?.count, 2)
        // These functions are dispatched async at the main thread
        wait(for: [view.showPostsExpectation, view.hideRefreshIndicatorExpectation], timeout: 1)
    }
    
    func testRefreshRequestedWithError() {
        // Given the presenter and the view, showing already two posts
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        presenter.posts = self.postsMocks
        
        // When refreshing is requested and an error occurs
        presenter.postsController = MockPostsController(posts: nil, error: NSError(domain: "test error", code: 1, userInfo: nil))
        presenter.refreshRequested()
        
        // Then
        XCTAssertEqual(presenter.posts?.count, 2)
        XCTAssertFalse(view.showPostsCalled)
        wait(for: [view.showErrrorExpectation, view.hideRefreshIndicatorExpectation], timeout: 1)
    }
    
    func testNextPageNeeded() {
        // Given the presenter and the view, showing already two posts
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        presenter.posts = self.postsMocks
        
        // When next page is requested and posts are returned
        presenter.postsController = MockPostsController(posts: self.postsMocks, error: nil)
        presenter.nextPageNeeded()
                
        // These function is dispatched async at the main thread
        wait(for: [view.showPostsExpectation], timeout: 1)
        XCTAssertEqual(presenter.posts?.count, 4)
    }
    
    func testPostDismissed() {
        // Given the presenter and the view, showing already two posts
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        presenter.posts = self.postsMocks
        
        // And given one of the shown posts identifier
        let postId = self.postsMocks.first!.identifier
        
        // When a post is dismissed
        presenter.postDismissed(uuid: postId)
        
        XCTAssertNil(presenter.posts?.first(where: { $0.identifier == postId}))
        XCTAssertEqual(presenter.posts?.count, 1)
        XCTAssert(view.showPostsCalled)
    }
    
    func testAllPostsDismissed() {
        // Given the presenter and the view, showing already two posts
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        presenter.posts = self.postsMocks
        
        // When all posts are dismissed
        presenter.allPostsDimissed()
        
        // Then
        XCTAssert(presenter.posts!.isEmpty)
        XCTAssert(view.showPostsCalled)
    }
    
    func testPostSelected() {
        // Given the presenter and the view, showing already two posts
        let view = HomeViewMock()
        let presenter = HomePresenter(view: view)
        presenter.posts = self.postsMocks
        
        // When a post is selected
        presenter.postSelected(index: 1)
        
        XCTAssert(presenter.posts![1].wasRead)
        XCTAssert(view.showPostsCalled)
        XCTAssert(view.showPostDetailCalled)
    }
}
