//
//  PostDetailPresenterTests.swift
//  RedditMateTests
//
//  Created by Samuel Sainz on 9/9/20.
//  Copyright © 2020 Samuel Sainz. All rights reserved.
//

import XCTest
@testable import RedditMate

class PostDetailPresenterTests: XCTestCase {
    
    class PostDetailViewMock: PostDetailView {
        
        var setDateCalled = false
        var setTitleCalled = false
        var setAuthorCalled = false
        var setSubredditCalled = false
        var setUpvotesCalled = false
        var setCommentsCalled = false
        var setImageCalled = false
        var setImageSizeCalled = false
        var showImageLoadingCalled = false
        var getImageCalled = false
        var showFullScreenImageCalled = false
        var showAllertCalled = false
        
        func setDate(text: String) {
            setDateCalled = true
        }
        
        func setTitle(text: String) {
            setTitleCalled = true
        }
        
        func setAuthor(text: String) {
            setAuthorCalled = true
        }
        
        func setSubreddit(text: String) {
            setSubredditCalled = true
        }
        
        func setUpvotes(text: String) {
            setUpvotesCalled = true
        }
        
        func setComments(text: String) {
            setCommentsCalled = true
        }
        
        func setImage(_ image: UIImage) {
            setImageCalled = true
        }
        
        func setImageSize(ratio: Float) {
            setImageSizeCalled = true
        }
        
        func showImageLoading() {
            showImageLoadingCalled = true
        }
        
        func getImage() -> UIImage? {
            getImageCalled = true
            return UIImage(systemName: "bin.xmark", withConfiguration: .none)
        }
        
        func showFullScreenImage(url: URL) {
            showFullScreenImageCalled = true
        }
        
        func showAlert(message: String) {
            showAllertCalled = true
        }
    }
    
    class MockImageFetcher: ImageFetcher {
        
        var fetchImageCalled = false
        
        override func fetchImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
            fetchImageCalled = true
            return nil
        }
    }
    
    class MockImageSaver: ImageSaver {
        
        var saveImageCalled = false
        
        override func saveImage(image: UIImage, completion: @escaping (Error?) -> Void) {
            saveImageCalled = true
            completion(nil)
        }
    }
     
    
    let mockPost = Post(name: "Name", title: "title", author: "author", ups: 12, subreddit: "subreddit", thumbnail: "http://thumbnail", thumbnailWidth: 123, thumbnailHeight: 123, created: Date().timeIntervalSince1970, numComments: 328, wasRead: false, images: PostImages(images: [PostImage(source: ImageData(url: "http://imageurl", width: 200, height: 200))]))
    
    func testSetupViewWithPost() {
        // Given the view and the presenter
        let view = PostDetailViewMock()
        let presenter = PostDetailPresenter(view: view)
        let mockImageSaver = MockImageSaver()
        let mockImageFetcher = MockImageFetcher()
        presenter.imageSaver = mockImageSaver
        presenter.imageFetcher = mockImageFetcher
        
        // When loading the view with a post
        presenter.setupViewWithPost(mockPost)
        
        // Then
        XCTAssert(view.setDateCalled)
        XCTAssert(view.setTitleCalled)
        XCTAssert(view.setAuthorCalled)
        XCTAssert(view.setSubredditCalled)
        XCTAssert(view.setUpvotesCalled)
        XCTAssert(view.setCommentsCalled)
        XCTAssert(mockImageFetcher.fetchImageCalled)
    }
    
    func testShowFullScreenImage() {
        // Given the view and the presenter
        let view = PostDetailViewMock()
        let presenter = PostDetailPresenter(view: view)
        presenter.post = mockPost
        
        // When user wants to expand the image
        presenter.expandImage()
        
        // Then
        XCTAssert(view.showFullScreenImageCalled)
    }
    
    func testDownloadImage() {
        // Given the view and the presenter
        let view = PostDetailViewMock()
        let presenter = PostDetailPresenter(view: view)
        presenter.post = mockPost
        let mockImageSaver = MockImageSaver()
        let mockImageFetcher = MockImageFetcher()
        presenter.imageSaver = mockImageSaver
        presenter.imageFetcher = mockImageFetcher
        
        // When user wants to download the image
        presenter.downloadImage()
        
        XCTAssert(view.getImageCalled)
        XCTAssert(mockImageSaver.saveImageCalled)
        XCTAssert(view.showAllertCalled)
    }
}
